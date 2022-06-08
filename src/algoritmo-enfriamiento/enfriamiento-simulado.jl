include("../algoritmos-busqueda/generar-vecino.jl")

function HeuristicaEnfriamiento(F_w, F_w_nuevo, T, k)
    u = rand()
    return u < exp((F_w - F_w_nuevo)/ (T*K))
end

"""
    Expresón para pasar avanzar en la construcción de la T
"""
macro SiguienteT(ß, T)
    quote
        $(esc(T))  / (1 + $(esc(ß))*$(esc(T)))
    end 
end 

"""
PrimeroMejor(numero_maximo_vecinos_sin_mejora::Int,
            evaluaciones_maximas_funcion_objetivo::Int,
            numero_atributos::Int, 
            umbral_atributo::Real, 
            F)::Vector{<:Real}

Devuelve mejor vector de peso encontrando de acorde
al algoritmo de enfriamiento simulado
"""
function EnfriamientoSimulado(evaluaciones_maximas_funcion_objetivo::Int,
    numero_atributos::Int, 
    umbral_atributo::Real, 
    F,  # fitness
    probabilidad_aceptar_peor = 0.3,
    temperatura_final = 10^(-3),
    numero_enfriamiento_realizar
    )::Vector{<:Real}

    w = rand(numero_atributos) # vector de tamaño atributo uniformement inicializado
    # Ponemos a cero atributos menores que umbral atributo
    w = map(x-> (x<umbral_atributo) ? 0 : x , w)

    evaluaciones = 0
    w_mejor = w
    F_w = F(w)
    F_w_mejor = F_w
    indice::Int = 1 
    T = µ * F_w / -log(probabilidad_aceptar_peor)
    ß = (T - temperatura_final) / (numero_enfriamiento_realizar * T * temperatura_final) 
    while (evaluaciones < evaluaciones_maximas_funcion_objetivo 
        &&
        T <= temperatura_final
    )
    # REVISARRRRR
        w_n = GenNeighbourhood(w, µ=0,var)
        F_w_vecino = F(w_n)
        
        if(F_w < F_w_vecino || HeuristicaEnfriamiento(F_w, F_w_vecino, T, k))
            w = w_n
            F_w = F_w_vecino
            if F_w_vecino > F_w_mejor
                w_mejor = w_n
                F_w_mejor = F_w_vecino
            end
        else
            # Si no hay mejora se cambia la exploración del atributo
            indice = indice % (numero_atributos)+1
        end
        evaluaciones += 1
    end
    return w_mejor
end

"""
    BL_LearnerOneNN(data::Matrix{<:Real}, labels::Vector{<:Real})
Devuelve un clasificado 1-NN refinado por unos pesos en la distancia euclídea. 
Ese vector de pesos se ha obtenido a partir de un algoritmo de búsqueda local 
"""
function EnfriamientoSimulado_LearnerOneNN(data::Matrix{<:Real}, labels)
    # Creamos función objetivo 
    a = 0.5
    umbral_tasa_reduccion = 0.1
    F = CrearFuncionObjetivo(data, labels, a, umbral_tasa_reduccion )

    numero_atributos = size(data)[2] # los atributos son las columnas 
    # Criterios de acorde a los requisitos 
    numero_maximo_vecinos_sin_mejora = 20 * numero_atributos 
    nuero_maximo_evaluaciones = 15000
    # Buscamos pesos de acorde a parámetros calculados
    w = EnfriamientoSimulado(numero_maximo_vecinos_sin_mejora,
    nuero_maximo_evaluaciones,numero_atributos,umbral_tasa_reduccion, F)

    return WeightedLearnerEuclideanOneNN(w, data, labels), F(w), w
end
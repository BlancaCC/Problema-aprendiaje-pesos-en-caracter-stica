include("../algoritmos-busqueda/generar-vecino.jl")
include("../learner/euclidean-1-NN.jl")
include("../algoritmos-busqueda/busqueda-local.jl")
include("../utils/funcion-objetivo.jl")

function HeuristicaEnfriamiento(F_w, F_w_nuevo, T)
    return rand() < exp((F_w - F_w_nuevo)/ (T*1.380649*10^(-23)))
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
    Expresión para calcular la beta 
"""
macro calculaß(T, T_f, M)
    quote
        ($(esc(T)) - $(esc(T_f)))/($(esc(M))*$(esc(T)) *$(esc(T_f)))
    end
end

"""
function EnfriamientoSimulado(
    evaluaciones_maximas_funcion_objetivo::Int,
    numero_atributos::Int, 
    umbral_atributo::Real, 
    F,  # fitness
    probabilidad_aceptar_peor = 0.3,
    temperatura_final = 10^(-3),
    maximo_vecinos,
    maximo_vecinos_aceptados
    )::Vector{<:Real}
Devuelve mejor vector de peso encontrando de acorde
al algoritmo de enfriamiento simulado
"""
function EnfriamientoSimulado(
    evaluaciones_maximas_funcion_objetivo::Int,
    numero_atributos::Int, 
    umbral_atributo::Real, 
    F,  # fitness
    probabilidad_aceptar_peor,
    temperatura_final,
    maximo_vecinos,
    maximo_vecinos_aceptados
    )::Vector{<:Real}
    µ = 0.3
    M = 15000/maximo_vecinos

    # inicializaciones
    w = rand(numero_atributos) # vector de tamaño atributo uniformement inicializado
    # Ponemos a cero atributos menores que umbral atributo
    w = map(x-> (x<umbral_atributo) ? 0 : x , w)
    w_mejor = w
    F_w = F(w)
    F_w_mejor = F_w

    vecinos_aceptados = 1
    evaluaciones = 0
    primera_iteracion = true

    T = µ * F_w / -log(probabilidad_aceptar_peor)
    ß = (T - temperatura_final) / (M * T * temperatura_final) 
    while ((evaluaciones < evaluaciones_maximas_funcion_objetivo 
        && vecinos_aceptados > 0
        &&
        T <= temperatura_final
    )
        ||
        primera_iteracion
    )
        #reseteamos valores
        vecinos_aceptados = 0
        vecinos_generados = 0
        primera_iteracion = false

        while( vecinos_generados < maximo_vecinos &&
            vecinos_aceptados < maximo_vecinos_aceptados)
            w_n = GenNeighbourhood(w, 0, 1)
            F_w_vecino = F(w_n)
            vecinos_generados += 1
            ß = @calculaß(T, temperatura_final, M)
            
            if(F_w < F_w_vecino || HeuristicaEnfriamiento(F_w, F_w_vecino, T))
                vecinos_aceptados += 1
                w = w_n
                F_w = F_w_vecino
                if F_w_vecino > F_w_mejor
                    w_mejor = w_n
                    F_w_mejor = F_w_vecino
                end
            end
        end
        evaluaciones += 1
        T = @SiguienteT(ß, T)
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
    probabilidad_aceptar_peor = 0.3
    temperatura_final = 10^(-3)
    numero_maximo_vecinos_sin_mejora = 20 * numero_atributos 
    evaluaciones_maximas_funcion_objetivo = 15000
    maximo_vecinos = 10*numero_atributos
    maximo_vecinos_aceptados = 0.1*maximo_vecinos
    # Buscamos pesos de acorde a parámetros calculados
    w = EnfriamientoSimulado(
        evaluaciones_maximas_funcion_objetivo,
        numero_atributos, 
        umbral_tasa_reduccion, 
        F,  # fitness
        probabilidad_aceptar_peor,
        temperatura_final,
        maximo_vecinos,
        maximo_vecinos_aceptados
    )

    return WeightedLearnerEuclideanOneNN(w, data, labels), F(w), w
end
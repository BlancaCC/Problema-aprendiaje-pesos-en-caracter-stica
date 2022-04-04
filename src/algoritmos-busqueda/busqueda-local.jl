include("generar-vecino.jl")

"""
PrimeroMejor(numero_maximo_vecinos_sin_mejora::Int,
            evaluaciones_maximas_funcion_objetivo::Int,
            numero_atributos::Int, 
            umbral_atributo::Real, 
            F)::Vector{<:Real}

Devuelve mejor vector de peso encontrando de acorde a función 
de evaluación `F`
"""
function PrimeroMejor(numero_maximo_vecinos_sin_mejora::Int,
    evaluaciones_maximas_funcion_objetivo::Int,
    numero_atributos::Int, 
    umbral_atributo::Real, 
    F)::Vector{<:Real}

    w = rand(numero_atributos) # vector de tamaño atributo uniformement inicializado

    # Ponemos a cero atributos menores que umbral atributo
    w = map(x-> (x<umbral_atributo) ? 0 : x , w)

    iteraciones = 0
    evaluaciones = 0
    F_w = F(w)
    indice::Int = 1 
    while iteraciones < numero_maximo_vecinos_sin_mejora &&
        evaluaciones < evaluaciones_maximas_funcion_objetivo
        w_n = GenNeighbourhoodIesimo(w,0, 0.3, indice)
        F_w_vecino = F(w_n)

        if(F_w < F_w_vecino)
            w = w_n
            F_w = F_w_vecino
            iteraciones = 0
        else
            # Si no hay mejora se cambia la exploración del atributo
            indice = indice % (numero_atributos)+1
        end
        iteraciones += 1
        evaluaciones += 1
    end
    return w
end
include("../learner/euclidean-1-NN.jl")
include("../algoritmos-busqueda/busqueda-local.jl")
include("../utils/funcion-objetivo.jl")

"""
    BMB_LearnerOneNN(data::Matrix{<:Real}, labels::Vector{<:Real},  iteraciones::Int)
Devuelve un clasificado 1-NN refinado por unos pesos en la distancia euclídea. 
Ese vector de pesos se ha obtenido a partir de un algoritmo de búsqueda local 
"""
function BMB_LearnerOneNN(data::Matrix{<:Real}, labels, iteraciones::Int=15)
    # Creamos función objetivo 
    a = 0.5
    umbral_tasa_reduccion = 0.1
    F = CrearFuncionObjetivo(data, labels, a, umbral_tasa_reduccion )
    w_mejor = 0
    F_w_mejor = -100 

    numero_atributos = size(data)[2] # los atributos son las columnas 
    # Criterios de acorde a los requisitos 
    numero_maximo_vecinos_sin_mejora = 20*numero_atributos 
    nuero_maximo_evaluaciones = 1000
    # Buscamos pesos de acorde a parámetros calculados
    for i in 1:iteraciones
        w = PrimeroMejor(numero_maximo_vecinos_sin_mejora,
        nuero_maximo_evaluaciones,numero_atributos,umbral_tasa_reduccion, F)
        f_w = F(w)
        if f_w > F_w_mejor
            w_mejor = w
            F_w_mejor = F_w_mejor
        end
    end
    return WeightedLearnerEuclideanOneNN(w_mejor, data, labels), F_w_mejor, w_mejor
end
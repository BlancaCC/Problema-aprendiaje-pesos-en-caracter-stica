export BL_LearnerOneNN

include("euclidean-1-NN.jl")
include("../algoritmos-busqueda/busqueda-local.jl")
include("../utils/funcion-objetivo.jl")

"""
    BL_LearnerOneNN(data::Matrix{<:Real}, labels::Vector{<:Real})
    Devuelve un clasificado 1-NN refinado por unos pesos en la distancia euclídea. 
    Ese vector de pesos se ha obtenido a partir de un algoritmo de búsqueda local 
"""
function BL_LearnerOneNN(data::Matrix{<:Real}, labels::Vector)
    # Creamos función objetivo 
    a = 0.5
    umbral_tasa_reduccion = 0.1
    F = CrearFuncionObjetivo(data, labels, a, umbral_tasa_reduccion )

    numero_atributos = size(data)[2] # los atributos son las columnas 
    # Criterios de acorde a los requisitos 
    numero_maximo_vecinos_sin_mejora = 20 * numero_atributos 
    nuero_maximo_evaluaciones = 15000
    w = PrimeroMejor(numero_maximo_vecinos_sin_mejora,
    nuero_maximo_evaluaciones,numero_atributos,umbral_tasa_reduccion, F)

    return WeightedLearnerEuclideanOneNN(w, data, labels), F(w), w
end
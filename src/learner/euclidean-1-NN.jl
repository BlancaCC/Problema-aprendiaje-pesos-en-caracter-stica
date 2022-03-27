include("../utils/one-NN.jl")
include("../utils/distancias.jl")

using .ModuleOneNN
using .ModuleDistances

export LearnerEuclideanOneNN
export WeightedLearnerEuclideanOneNN

"""
    LearnerEuclideanOneNN(data, labels)

Devuelve un clasificador 1-NN basado en la distancia Euclídea 
"""
function LearnerEuclideanOneNN(data, labels)
    return f(x)= OneNN(x, EuclideanDistance, data, labels)
end

"""
    WeightedLearnerEuclideanOneNN(w,data, labels)

Devuelve un clasificador 1-NN basado en la distancia Euclídea 
ponderada a `w`

"""
function WeightedLearnerEuclideanOneNN(w,data, labels)
    distance(x,y)=WeightedEuclideanDistance(x,y,w)
    return f(x)= OneNN(x, distance, data, labels)
end
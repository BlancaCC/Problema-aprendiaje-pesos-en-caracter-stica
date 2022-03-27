include("../utils/one-NN.jl")
include("../utils/distancias.jl")

using .ModuleOneNN
using .ModuleDistances
export LearnerEuclideanOneNN

"""
    LearnerEuclideanOneNN(data, labels)
    
"""
function LearnerEuclideanOneNN(data, labels)
    return f(x)= OneNN(x, EuclideanDistance, data, labels)
end
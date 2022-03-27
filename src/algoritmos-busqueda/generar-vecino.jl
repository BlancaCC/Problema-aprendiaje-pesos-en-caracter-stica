export GenNeighbourhood

using Random, Distributions
#Random.seed!(123) # Setting the seed

"""
    GenNeighbourhood(w::Vector{Real} ,µ::Real, var ::Real)
    Devuelve vecino del vector `w` de acorde a una normal 
    de media `µ` y varianza `var`. 
"""
function GenNeighbourhood(w::Vector{<:Real} ,µ::Real, var ::Real)::Vector{<:Real}
    distribution = Normal(µ, var)
    z=rand(distribution,size(w))
    w_new = map(
        x -> min(1, max(0,x)),
        w-z
    )
    return w_new
end
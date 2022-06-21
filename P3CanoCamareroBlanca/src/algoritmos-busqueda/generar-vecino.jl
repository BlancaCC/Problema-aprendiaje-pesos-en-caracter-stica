export GenNeighbourhood
export GenNeighbourhoodIesimo

using Distributions
using Random
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


"""
GenNeighbourhoodIesimo(w::Vector{<:Real} ,µ::Real, var ::Real, index::Int)::Vector{<:Real}
    Devuelve vecino del vector `w` de acorde a una normal 
    de media `µ` y varianza `var` donde solo se ha cambia la componente iéxima. 
"""
function GenNeighbourhoodIesimo(w::Vector{<:Real} ,µ::Real, var ::Real, index::Int)::Vector{<:Real}
    distribution = Normal(µ, var)
    z=rand(distribution)
    w_new = w
    w_new[index] = min(1, max(0,w_new[index]-z))
    return w_new
end

"""
GenNeighbourhoodIesimo(w::Vector{<:Real} ,µ::Real, var ::Real, index::Int)::Vector{<:Real}
    Devuelve vecino del vector `w` de acorde a una normal 
    de media `µ` y varianza `var` donde solo se ha cambia la componente iéxima. 
"""
function GenNeighbourhoodIesimo(w::Vector{<:Real} ,µ::Real, var ::Real, n:: Int, coeficiente::Real )::Vector{<:Real}
    index = first(randperm(n), round(Int, coeficiente*n))
    distribution = Normal(µ, var)
    w_new = w
    for i in index 
        w_new[i] = min(1, max(0,w_new[i]-rand(distribution)))
    end
    return w_new
end
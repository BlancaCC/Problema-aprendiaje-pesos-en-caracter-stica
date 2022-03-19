include("../one-NN.jl")
include("../distancias.jl")

using Test
using .ModuleOneNN
using .ModuleDistances

data = [-1 0; 1 1]
class = ['-', '+']

@testset "Funcion 1-NN" begin 
    @test OneNN([2,2], EuclideanDistance, data, class ) == '+'
    @test OneNN([-1,-3], EuclideanDistance, data, class ) == '-'

end
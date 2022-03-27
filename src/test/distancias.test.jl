using Test 
include("../utils/distancias.jl")
using .ModuleDistances

@testset "Distancias" begin 
    @test EuclideanDistance([1,1,0],[2,1,2]) == sqrt(5)
    @test WeightedEuclideanDistance([1,1,1],[1,1,0],[5,5,4]) == 2.0
end
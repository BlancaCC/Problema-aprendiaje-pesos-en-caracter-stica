using Test
include("../../learner/RELIEF.jl")

data = [-1 0 1; 1 1 1; -1 -3 1; 1 -2 2; 9 -1 2; 1 2 2; 10 20 1]
labels = ['-', '+',  '-',   '-',  '-', '+' , '+' ]

@testset "Relief algoritmo" begin 
    w = RELIEF(data, labels)
    @test length(w) == length(data[1,:])
    @test minimum(w) >= 0
    @test maximum(w) <= 1
end 
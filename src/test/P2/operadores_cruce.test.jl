####################################
# Test de operadores de cruce 
#   BLX
####################################
using  Test
include("../../operadores_cruce/BLX.jl")

@testset "BLX " begin
    n = 10
    c1 = rand(n)
    c2 = rand(n)
    alpha = 0.3
    h1, h2 = BLX(c1,c2, alpha)
    @test length(h1) == n
    @test length(h2) == n
end
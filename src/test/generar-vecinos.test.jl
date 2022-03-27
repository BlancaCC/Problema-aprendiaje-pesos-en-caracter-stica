using Test 
include("../algoritmos-busqueda/generar-vecino.jl")

@testset "Buscar vecino" begin 
    w = [0.5, 0.5, 0.5]
    m = 0
    s = 0.3
w_n = GenNeighbourhood(w, m, s)
    for i in 1:5
        @test size(w_n) == size(w)
        @test !(false in map( x-> 0<= x <= 1, w_n))
        w = w_n
        GenNeighbourhood(w, m, s)
    end
end
using Test 
#include("../algoritmos-busqueda/generar-vecino.jl")
#include("../algoritmos-busqueda/busqueda-local.jl")
include("../../learner/BL-euclidean-1-NN.jl")

@testset "Buscar vecino cambiando todo " begin 
    w = [0.5, 0.5, 0.5]
    m = 0
    s = 0.3
    w_n = GenNeighbourhood(w, m, s)
    for i in 1:3
        @test size(w_n) == size(w)
        @test !(false in map( x-> 0<= x <= 1, w_n))
        w = w_n
        GenNeighbourhood(w, m, s)
    end
end
@testset "Buscar vecino un índice concreto" begin 
    for i in 1:5
        w = [0.5, 0.5, 0.5, 0.5, 0.5]
        m = 0
        s = 0.3
        w_n = GenNeighbourhoodIesimo(w, m, s, i)
        @test size(w_n) == size(w)
        @test !(false in map( x-> 0<= x <= 1, w_n))
        @test w[1:i-1] == w_n[1:i-1]
        @test w[i+1:5] == w_n[i+1:5]
    end
end

@testset "Primero mejor" begin 
    F(x)=sum(x) # Función de evaluación simple
    
    for tam in 12:15
        w = PrimeroMejor(10, 2, tam, 0.3, F)
        @test length(w) == tam
        @test !(false in map( x-> 0<= x <= 1, w))
    end
end

@testset "Busqueda local learner" begin 
    # El último parámetro es "aleatorio"
    data = [-1 0 1; 1 1 1; -1 -3 1; 1 -2 2; 9 -1 2; 1 2 2; 10 20 1]
    class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]
    clasificador, funcion_evaluacion , w = BL_LearnerOneNN(data, class)

end 
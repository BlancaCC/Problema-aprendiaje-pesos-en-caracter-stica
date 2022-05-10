using Test
include("../utils/funcion-objetivo.jl")

@testset "Función objetivo" begin 
    data = [-1 0; 1 1; -1 -3; 1 -2; 9 -1; 1 2; 10 20]
    class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]
    F=CrearFuncionObjetivo(data, class, 0.5, 0.3)
    @test 0<= F([0.1,0.5]) <= 100
end 
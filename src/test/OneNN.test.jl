include("../one-NN.jl")
include("../distancias.jl")
include("../validation.jl")

using Test
using .ModuleOneNN
using .ModuleDistances
using .ModuleValidation

data = [-1 0; 1 1; -1 -3; 1 -2; 9 -1; 1 2; 10 20]
class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]

@testset "Función 1-NN" begin 
    @test OneNN([2,2], EuclideanDistance, data, class ) == '+'
    @test OneNN([-1,-3], EuclideanDistance, data, class ) == '-'

end

# Distribución de índices 
# tamaño 7, tomado en 3 folds [3,5, 7], 123 45 67
l1 = [3,5,7]
l1_test = [CalculateIndex(3,7,i) for i in 1:3 ]
# tamaño 8, tomado en 3 folds [3,6,8] 123 456 78
l2 = [3,6,8]
l2_test = [CalculateIndex(3,8,i) for i in 1:3 ]
# tamaño 9, tomado en 4 folds [3,5, 7, 9] 123 45 67 89
l3 = [3,5,7, 9]
l3_test = [CalculateIndex(4,9,i) for i in 1:4 ]
@testset "Index distribution" begin 
    @test l1 == l1_test
    @test l2 == l2_test
    @test l3 == l3_test
end
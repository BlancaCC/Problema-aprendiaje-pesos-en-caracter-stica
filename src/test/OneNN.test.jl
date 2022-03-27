include("../one-NN.jl")
include("../distancias.jl")
include("../validation.jl")
include("../naive-classifiers/constant.jl")
include("../learner/euclidean-1-NN.jl")

using Test
using .ModuleOneNN
using .ModuleDistances
using .ModuleValidation
using .ModuleNaiveClassifiers

data = [-1 0; 1 1; -1 -3; 1 -2; 9 -1; 1 2; 10 20]
class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]

@testset "Función 1-NN" begin 
    @test OneNN([2,2], EuclideanDistance, data, class ) == '+'
    @test OneNN([-1,-3], EuclideanDistance, data, class ) == '-'

    oneNN_from_learner = LearnerEuclideanOneNN(data, class)
    @test oneNN_from_learner([2,2]) == '+'
    @test oneNN_from_learner([-1,-3]) == '-'

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


@testset "Naive Classifiers" begin 
    cte = ConstantLearned([1,1,1], [1,2,3])
    @test cte(123) == 1
end

@testset "CrossValidation" begin 
    for tam in 10:15
        data = rand(tam, tam)
        label = rand(tam)
        for folds_number in 1:7
            time, accuracy = CrossValidation(
                data,
                label, 
                folds_number,
                ConstantLearned
            )
            @test accuracy ≈ 100
        end
    end
    
    data = [-1 0; 1 1; -1 -3; 1 -2; 9 -1; 1 2; 10 20]
    class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]
    time, accuracy = CrossValidation(
        data,
        class,
       4,
       LearnerEuclideanOneNN 
    )
    @test 0<= accuracy <=100
end


@testset "Leave one out" begin 
    
    data = [-1 0; 1 1; -1 -3; 1 -2; 9 -1; 1 2; 10 20]
    class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]
    accuracy = LeaveOneOut(
        data,
        class,
       LearnerEuclideanOneNN 
    )
    @test 0<= accuracy <=100
end
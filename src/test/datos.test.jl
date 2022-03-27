using Test 

include("../utils/preprocesado_datos.jl")
using .ModuloDatos

file_path= "src/Instancias_APC/"

struct DataFile
    route::String
    class_atributte::String
end

files = [
    DataFile(file_path*"ionosphere.arff", "class"),
    DataFile(file_path*"parkinsons.arff", "Class"),
    DataFile(file_path*"spectf-heart.arff", "Class"),
]

@testset "Carga y normalizacición de los datos" begin 
    for file in files
        data , labels = DataLabelArff(file.route, file.class_atributte)
        for col in data
            @test 0 <= minimum(col)
            @test 1 >= maximum(col)
        end
    end
end



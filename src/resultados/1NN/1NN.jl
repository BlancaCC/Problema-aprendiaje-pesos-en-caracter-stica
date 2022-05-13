using Random

## Leer datos 
include("../../utils/preprocesado_datos.jl")
include("../../utils/validation.jl")
include("../../learner/euclidean-1-NN.jl")

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
csv_file_path  = "src/resultados/1NN/"

process_name = [
    DataFile(csv_file_path*"1NN-ionosphere.result.csv", "Datos Iosfera"),
    DataFile(csv_file_path*"1NN-parkinsons.result.csv", "Datos parkinson "),
    DataFile(csv_file_path*"1NN-spectf-heart.result.csv", "Datos ataques corazón")
]
Random.seed!(0)
for i in 1:length(files)
    file = files[i]
    data , labels = DataLabelArff(file.route, file.class_atributte)
    ## Entrenar para obtener el peso 
    println("==============================================")
    println("$(process_name[i].class_atributte)")
    w = ones(size(data)[2])

    clasificador(data,labels)=LearnerEuclideanOneNN(data, labels), 0, w
    ## Evaluar resultado con cross validation 
    VerboseCrossValidation(data, labels, 5, clasificador, process_name[i].route)
end
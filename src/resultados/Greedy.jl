## Leer datos 
using Random

## Leer datos 
include("../utils/preprocesado_datos.jl")
include("../utils/validation.jl")
include("../utils/funcion-objetivo.jl")
include("../learner/RELIEF.jl")

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
csv_file_path  = "src/resultados/Greedy/"
prefijo = "Greedy-"
process_name = [
    DataFile(csv_file_path*prefijo*"ionosphere.result.csv", "Datos Iosfera"),
    DataFile(csv_file_path*prefijo*"parkinsons.result.csv", "Datos parkinson "),
    DataFile(csv_file_path*prefijo*"spectf-heart.result.csv", "Datos ataques corazón")
]
#Random.seed!(0)
println("Procedemos a calcular los datos con $(Threads.nthreads()) hebras disponibles")

for i in 1:length(files)
    # Seleccionamos parkinson
    file = files[i]
    data , labels = DataLabelArff(file.route, file.class_atributte)

    ## Entrenar para obtener el peso 
    println("==============================================")
    println("$(process_name[i].class_atributte)")

    ## Evaluar resultado con cross validation 
    VerboseCrossValidation(data, labels, 5, RELIEF_LearnerOneNN, process_name[i].route)
end
## Leer datos 
using Random

## Leer datos 
include("../../utils/preprocesado_datos.jl")
include("../../utils/validation.jl")
include("../../ILS/ILS.jl")

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
# ¡Tiene que acabar en /
csv_file_path  = "src/resultados/ILS/"
prefijo = "ILS-"
process_name = [
    DataFile(csv_file_path*prefijo*"ionosphere.result.csv", "Datos Iosfera"),
    DataFile(csv_file_path*prefijo*"parkinsons.result.csv", "Datos parkinson "),
    DataFile(csv_file_path*prefijo*"spectf-heart.result.csv", "Datos ataques corazón")
]
Random.seed!(0)
println("Procedemos a calcular los datos con $(Threads.nthreads()) hebras disponibles")
# Leemos los argumentos para saber el fichero que se quiere ejecutar 
# si el argumento no existe, hay ambigüedad o no es un ínice de ficheros se ejecutan todos
if length(ARGS) == 1 && parse(Int,ARGS[1]) in [1,2,3]
    n = parse( Int, ARGS[1] )
    inicio = n
    final = n
else
    inicio = 1
    final = length(files)
end
    
for i in inicio:final
    # Seleccionamos parkinson
    file = files[i]
    data , labels = DataLabelArff(file.route, file.class_atributte)
    ## Entrenar para obtener el peso 
    println("==============================================")
    println("$(process_name[i].class_atributte)")

    ## Evaluar resultado con cross validation 
    VerboseCrossValidationS(data, labels, 5, ILS_LearnerOneNN, process_name[i].route)
end

############################
## Extrae los resultados concernientes al algoritmo AGG_BLX para los tres data set concerniente
############################

using Random
## Leectura de datos
include("../../../../utils/preprocesado_datos.jl")
include("../../../../utils/validation.jl")
## Algoritmo de aprendizaje que se va a usar 
include("../../../../algoritmos-geneticos/AGG.jl")
# Operador de cruce
include("../../../../algoritmos-geneticos/operadores_cruce/BLX.jl")
# Operador de mutación es el de generar vecino de búsqueda local 
include("../../../../algoritmos-busqueda/generar-vecino.jl")
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
# Directorio donde se guardará el fichero
csv_file_path  = "src/resultados/Genéticos/AGG/BLX/"
iniciales_nombre = "AGG-BLX-"
process_name = [
    DataFile(csv_file_path*iniciales_nombre*"ionosphere.result.csv", "Datos Iosfera"),
    DataFile(csv_file_path*iniciales_nombre*"parkinsons.result.csv", "Datos parkinson "),
    DataFile(csv_file_path*iniciales_nombre*"spectf-heart.result.csv", "Datos ataques corazón")
]
i = 1
Random.seed!(0)
file = files[i] # Parkinson
data , labels = DataLabelArff(file.route, file.class_atributte)

f_mutación(x) = GenNeighbourhood(x, 0, 0.3) # Coincide con el BL de la práctica P1

# Devolvemos la función que aprende de los datos 
AGG_BLX_LearnerOneNN(data, labels)= AGG_LearnerOneNN(
    data, labels,
     40, #evaluaciones_máximas_FE 
     30, # numero_cromosomas_por_generación 
    0.7, # probabilidad_cruce 
    0.1, # probabilidad_mutación 
    size(data)[2], # tamaño_cromosoma = número atributos
    BLX, # función_cruce 
    f_mutación # función_mutación 
)

VerboseCrossValidation(data, labels, 5, AGG_BLX_LearnerOneNN, process_name[i].route)


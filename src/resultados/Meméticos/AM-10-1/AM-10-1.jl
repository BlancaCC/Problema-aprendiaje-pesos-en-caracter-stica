############################
## Extrae los resultados concernientes al algoritmo AGE_BLX para los tres data set concerniente
############################

using Random
## Leectura de datos
include("../../../utils/preprocesado_datos.jl")
include("../../../utils/validation.jl")
## Algoritmo de aprendizaje que se va a usar 
include("../../../algoritmo-memetico/memetico.jl")
# Operador de cruce
include("../../../algoritmos-geneticos/operadores_cruce/Media.jl")
# Operador de mutación es el de generar vecino de búsqueda local 
include("../../../algoritmos-busqueda/generar-vecino.jl")
# Algoritmo de selección de índices  a los que aplicar búsqueda local 
include("../../../algoritmo-memetico/seleccion-cromosomas/porcentaje-cromosomas.jl")

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

csv_file_path  = "src/resultados/Meméticos/AM-10-1"
iniciales_nombre = "AM-(10,1)-"
process_name = [
    DataFile(csv_file_path*iniciales_nombre*"ionosphere.result.csv", "Datos Iosfera"),
    DataFile(csv_file_path*iniciales_nombre*"parkinsons.result.csv", "Datos parkinson "),
    DataFile(csv_file_path*iniciales_nombre*"spectf-heart.result.csv", "Datos ataques corazón")
]
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
    Random.seed!(0)
    file = files[i] # Parkinson
    data , labels = DataLabelArff(file.route, file.class_atributte)

    f_mutación(x) = GenNeighbourhood(x, 0, 0.3) # Coincide con el BL de la práctica P1

    # Devolvemos la función que aprende de los datos 
    AM_LearnerOneNN(data, labels)= Memetico_LearnerOneNN(
        data, labels,
        15000, #evaluaciones_máximas_FE 
        10, # numero_cromosomas_por_generación
        0.7, #probabilidad_cruce 
        0.1, # probabilidad_mutación 
        size(data)[2], # tamaño_cromosoma = número atributos
        MediaPonderada, # función_cruce 
        f_mutación, # función_mutación
        1.0,#porcentaje_cromosomas_busqueda_local,
        IndiceCromosomasProbabilidad,#funcion_selección_índices_para_busqueda_local, 
        10 #numero_generaciones_aplicar_bl = 10,
    )
     VerboseCrossValidation(data, labels, 5, AM_LearnerOneNN, process_name[i].route)
end
## Leer datos 
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
# Seleccionamos parkinson
file = files[2]
data , labels = DataLabelArff(file.route, file.class_atributte)



## Entrenar para obtejer el peso 

## Evaluar resultado con cross validation 
using ARFFFiles, DataFrames
using Random

"""
    Normalize(vector)
Devuelve un vector de datos normalizados 
"""
function Normalize(vector)
    max = maximum(vector)
    min = minimum(vector)
    diff = (max-min)
    reescale = diff ≈ 0 ? 1 : diff

    return map( x -> (x - min)/reescale, vector)
end 
"""
    DataLabel(file) 
Dado un fichero .arff devuleve: 
1. matriz de datos normalizados, cada columna una categoría
2. Las etiquetas

Se supone que:
1. Class es la última categoría y contiene las categorías.
2. Que  el resto son numéricas
"""
function DataLabelArff(file, class_name)
    Random.seed!(0)
    df = ARFFFiles.load(DataFrame, file)
    labels = df[!, "$class_name"]
    attributes  = names(df)
    pop!(attributes) # Elimina la clase
    data = [ 
            Normalize(df[!,"$name"]) 
            for name in attributes
    ]
    data = reduce(hcat, data)

    # desordenamos los datos 
    index = shuffle(1:length(labels))
    data = data[index, :]
    labels = labels[index]
    
    return data, labels
end

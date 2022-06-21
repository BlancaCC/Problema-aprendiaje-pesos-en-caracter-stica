using CSV
using DataFrames
using Statistics

"""
    CalculateIndex(fold::Integer, len::Integer, index::Integer)
Calcula el índice final de la partición `index`de  de un conjunto de `len` elementos, dividido en `fold` partes.
Si la división no es exacta se cogerán más elementos en las particiones primeras, todo elemento de la lista tiene asociado una partición.

Ejemplos: 
# tamaño 7, tomado en 3 folds [3,5, 7], 123 45 67
l1 = [3,5,7]
l1_test = [CalculateIndex(3,7,i) for i in 1:3 ]
# tamaño 8, tomado en 3 folds [3,6,8] 123 456 78
l2 = [3,6,8]
l2_test = [CalculateIndex(3,8,i) for i in 1:3 ]
# tamaño 9, tomado en 4 folds [3,5, 7, 9] 123 45 67 89
l3 = [3,5,7, 9]
l3_test = [CalculateIndex(4,9,i) for i in 1:4 ]
"""
CalculateIndex(fold::Integer, len::Integer, index::Integer)=index*floor(Int, len/fold)+((mod(len,fold) >= (index)) ? index : mod(len,fold))

"""
    VerboseCrossValidation(data, labels, folds_number, learner_algorithm, file_name::String, 
    umbral_tasa_reduccion=0.1, a = 0.5)
Divide el conjunto de datos en `folds_number` particiones disjuntas.
Repite `folds_number` veces: 
entrena con `folds_number-1` conjuntos y valida con el restante. 

La validación será la tasa media de acierto, también se evaluará el tiempo.
"""
function VerboseCrossValidation(data, labels, folds_number, learner_algorithm, file_name::String, 
    umbral_tasa_reduccion=0.1, a = 0.5)

    # Datos que vamos a escribir
    tamaño = folds_number+2
    dfParticion = map( x -> "Partición $x", 1:(tamaño))
    dfTime = Array{Float64}(undef, tamaño)
    dfClasificacion = Array{Float64}(undef, tamaño)
    dfReduccion =  Array{Float64}(undef, tamaño)
    dfAgregacion = Array{Float64}(undef, tamaño)
    dfW = Array{Vector{Float64}}(undef, tamaño)
    # calculate folds 
    len = length(labels)
    index = [ 
        CalculateIndex(folds_number,len,i) for i in 0:folds_number
        ]
    lk = ReentrantLock() 

    Threads.@threads for i in 1:folds_number
        lock(lk)
            println("Comienza la iteración $i/$folds_number de CV para $file_name")
        unlock(lk)
        # select train data and test 
        train_index = filter(
            x-> x<= index[i] || x > index[i+1] , 1:len
        )
        
        test_index = (index[i]+1):index[i+1]
        
        train_data = data[train_index , :]
        train_labels = labels[train_index]
        test_data = data[test_index, :]
        test_labels = labels[test_index]
        
        time = @elapsed begin 
            # train
            clasificator, F_w, w = learner_algorithm(train_data, train_labels)
            # test
            estimations =  map(clasificator, eachrow(test_data))
        end
        # Calculamos la precisión
        aciertos = sum(estimations .== test_labels)
        accuracy = (aciertos/ (index[i+1] - index[i]) )* 100
        # Calculamos tasa de reducción valor entre [0,100]
        tasa_reducion = 100*sum(
            map(x-> (x < umbral_tasa_reduccion) ? 1 : 0, w)
            )/length(w)
        # Evaluación combinación de ambas
        evaluacion = a*accuracy + (1-a)*tasa_reducion

        # Guardamos datos que se escribirán en el fichero 
       #            s -> x1000 ms
        dfTime[i] = time#*1000
        dfAgregacion[i] = evaluacion
        dfClasificacion[i] = accuracy
        dfReduccion[i] = tasa_reducion
        dfW[i] = w   
        lock(lk)
        # habría que hacer esto con un cerrojo
            println("------------------------------------")
            println("Termina iteración $i/$folds_number de CV para $file_name con: 
            Tiempo (s): $(dfTime[i])  tasa clasificación: $accuracy  tasa reducción: $tasa_reducion agregación: $evaluacion 
            w = $w\n")
            println("------------------------------------")
        unlock(lk)
 
    end
    # Añadimos medias 
    # Calculamos las medias
    tamaño -=1
    dfParticion[tamaño] = "Medias "
    dfTime[tamaño]= mean(dfTime[1:folds_number])
    dfClasificacion[tamaño]= mean(dfClasificacion[1:folds_number])
    dfReduccion[tamaño]= mean(dfReduccion[1:folds_number])
    dfAgregacion[tamaño]= mean(dfAgregacion[1:folds_number])
    dfW[tamaño]= mean(dfW[1:folds_number])
    # Calculamos las desviaciones típicas 
    tamaño += 1
    dfParticion[tamaño] = "Desviación típica"
    dfTime[tamaño]= std(dfTime[1:folds_number])
    dfClasificacion[tamaño]= std(dfClasificacion[1:folds_number])
    dfReduccion[tamaño]= std(dfReduccion[1:folds_number])
    dfAgregacion[tamaño]= std(dfAgregacion[1:folds_number])
    dfW[tamaño]= std(dfW[1:folds_number])

    # Escribimos en el fichero 
    DF = DataFrame(
        Nombre_Fila = dfParticion, 
        Clasificación = dfClasificacion,
        Reducción = dfReduccion, 
        Agregación = dfAgregacion, 
        Tiempo = dfTime,
        Pesos = dfW
    )
    println("Se proceden a escribir en $file_name los datos $DF")
    CSV.write(file_name, DF)

    return DF
end

"""
    LeaveOneOut(data, labels, learner_algorithm)
"""
function LeaveOneOut(data, labels, learner_algorithm)
    # calculate folds 
    len = length(labels)
    accuracy = 0
    for i in 1:len
        index = union(1:(i-1), (i+1):len)
        clasificator = learner_algorithm(data[index , :], labels[index])

        accuracy += ( clasificator(data[i]) == labels[i]) ? 0 : 1
    end
    accuracy = accuracy*100/len
    return accuracy
end

function VerboseCrossValidationS(data, labels, folds_number, learner_algorithm, file_name::String, 
    umbral_tasa_reduccion=0.1, a = 0.5)

    # Datos que vamos a escribir
    tamaño = 1+2
    dfParticion = map( x -> "Partición $x", 1:(tamaño))
    dfTime = Array{Float64}(undef, tamaño)
    dfClasificacion = Array{Float64}(undef, tamaño)
    dfReduccion =  Array{Float64}(undef, tamaño)
    dfAgregacion = Array{Float64}(undef, tamaño)
    dfW = Array{Vector{Float64}}(undef, tamaño)
    # calculate folds 
    len = length(labels)
    index = [ 
        CalculateIndex(folds_number,len,i) for i in 0:folds_number
        ]
    lk = ReentrantLock() 

    Threads.@threads for i in 1:1
        lock(lk)
            println("Comienza la iteración $i/$folds_number de CV para $file_name")
        unlock(lk)
        # select train data and test 
        train_index = filter(
            x-> x<= index[i] || x > index[i+1] , 1:len
        )
        
        test_index = (index[i]+1):index[i+1]
        
        train_data = data[train_index , :]
        train_labels = labels[train_index]
        test_data = data[test_index, :]
        test_labels = labels[test_index]
        
        time = @elapsed begin 
            # train
            clasificator, F_w, w = learner_algorithm(train_data, train_labels)
            # test
            estimations =  map(clasificator, eachrow(test_data))
        end
        # Calculamos la precisión
        aciertos = sum(estimations .== test_labels)
        accuracy = (aciertos/ (index[i+1] - index[i]) )* 100
        # Calculamos tasa de reducción valor entre [0,100]
        tasa_reducion = 100*sum(
            map(x-> (x < umbral_tasa_reduccion) ? 1 : 0, w)
            )/length(w)
        # Evaluación combinación de ambas
        evaluacion = a*accuracy + (1-a)*tasa_reducion

        # Guardamos datos que se escribirán en el fichero 
       #            s -> x1000 ms
        dfTime[i] = time#*1000
        dfAgregacion[i] = evaluacion
        dfClasificacion[i] = accuracy
        dfReduccion[i] = tasa_reducion
        dfW[i] = w   
        lock(lk)
        # habría que hacer esto con un cerrojo
            println("------------------------------------")
            println("Termina iteración $i/$folds_number de CV para $file_name con: 
            Tiempo (s): $(dfTime[i])  tasa clasificación: $accuracy  tasa reducción: $tasa_reducion agregación: $evaluacion 
            w = $w\n")
            println("------------------------------------")
        unlock(lk)
 
    end
    # Añadimos medias 
    # Calculamos las medias
    folds_number = 1
    tamaño -=1
    dfParticion[tamaño] = "Medias "
    dfTime[tamaño]= mean(dfTime[1:folds_number])
    dfClasificacion[tamaño]= mean(dfClasificacion[1:folds_number])
    dfReduccion[tamaño]= mean(dfReduccion[1:folds_number])
    dfAgregacion[tamaño]= mean(dfAgregacion[1:folds_number])
    dfW[tamaño]= mean(dfW[1:folds_number])
    # Calculamos las desviaciones típicas 
    tamaño += 1
    dfParticion[tamaño] = "Desviación típica"
    dfTime[tamaño]= std(dfTime[1:folds_number])
    dfClasificacion[tamaño]= std(dfClasificacion[1:folds_number])
    dfReduccion[tamaño]= std(dfReduccion[1:folds_number])
    dfAgregacion[tamaño]= std(dfAgregacion[1:folds_number])
    dfW[tamaño]= std(dfW[1:folds_number])

    # Escribimos en el fichero 
    DF = DataFrame(
        Nombre_Fila = dfParticion, 
        Clasificación = dfClasificacion,
        Reducción = dfReduccion, 
        Agregación = dfAgregacion, 
        Tiempo = dfTime,
        Pesos = dfW
    )
    println("Se proceden a escribir en $file_name los datos $DF")
    CSV.write(file_name, DF)

    return DF
end


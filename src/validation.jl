module ModuleValidation
export CrossValidation
export CalculateIndex

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
    CrossValidation(data, labels, folds_number, algorithm)
Divide el conjunto de datos en `folds_number` particiones disjuntas.
Repite `folds_number` veces: 
entrena con `folds_number-1` conjuntos y valida con el restante. 

La validación será la tasa media de acierto, también se evaluará el tiempo.
"""
function CrossValidation(data, labels, folds_number, learner_algorithm)
    # calculate folds 
    len = length(class)
    index = [ CalculateIndex(folds_number,len,i) for i in 0:folds_number]

    for i in 1:folds_number
        train_index = filter(
            x-> x<= index[i] || x > index[i+1] , 1:len
        )
        test_index = (index[i]+1):index[i+1]
        
        train_data = data[train_index , :]
        train_labels = labels[train_index]
        data_test = data[test_index, :]
        data_labels = labels[test_index]

        #TODO test accuracy and time
        clasificator = learner_algorithm(train_data, train_labels)
        time = @elapsed begin 
        estimations =  map(clasificador, data_test)
        end

        # TODO save time and accuracy 
    end

    # Calculate metrics
end

end #module 
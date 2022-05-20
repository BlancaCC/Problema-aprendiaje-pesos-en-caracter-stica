############################################################
#  Devuelve el índice de tantos cromosomas a buscar 
############################################################
"""
    IndiceCromosomasProbabilidad(tamaño, porcentaje_seleccion, valores)
Devuelve lista con los índices a mutar 

Tamaño es el tamaño de los cromosomas 
porcentaje_seleccion flotante entre (0,1]
valores: no se utilizan para nada, es por manterner la cabecera de ese tipo de funciones 
"""
function IndiceCromosomasProbabilidad(tamaño, porcentaje_seleccion, valores)
    cantidad_indices = round(Int, porcentaje_seleccion* tamaño)
    permutaciones = randperm(tamaño)
    return permutaciones[1:cantidad_indices]
end

"""
    MejoresCromosomas(tamaño, porcentaje_seleccion, valores)
Devuelve una lista con los índices a mutar 
Concretamemente un subconjunto de tamaño tamaño*porcentaje_seleccion con los mejores cromosomas 
"""
function MejoresCromosomas(tamaño, porcentaje_seleccion, valores)
    cantidad_indices = round(Int, porcentaje_seleccion* tamaño)
    permutaciones = Array{Int, }(undef, cantidad_indices)
    valores_aux = copy(valores)

    for i in 1:cantidad_indices
        indice_mejor = argmax(valores_aux)
        permutaciones[i] = indice_mejor
        valores_aux[i] = -1 # valor por debajo del válido
    end 
    return permutaciones
end 

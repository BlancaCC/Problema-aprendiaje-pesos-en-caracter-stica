#################################
## Generar cromosoma 
##########################

"""
    GeneraCromosoma( tamaño, umbral )
Cromosoma con componentes uniformes 
"""
function GeneraCromosoma( tamaño, umbral )
    cromosoma = rand(tamaño)
    return map( x -> x < umbral ? 0.0 : x, cromosoma)
end
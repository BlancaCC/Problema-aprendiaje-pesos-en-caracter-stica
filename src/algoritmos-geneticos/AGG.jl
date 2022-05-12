##################################
# ALGORITMO GENÉTICO GENERALISTA 
##################################
using Random

include("generar-cromosoma.jl")
include("torneo-binario.jl")
function AGG(   evaluaciones_máximas_FE, 
                numero_cromosomas_por_generación, 
                probabilidad_cruce,
                probabilidad_mutación. 
                tamaño_cromosoma, 
                función_evaluación, 
                función_cruce, 
                función_mutación)
    # Generamos la primera generación 

    generación = [GeneraCromosoma(tamaño_cromosoma, 0.1) for i in 1:numero_cromosomas_por_generación]
    evaluaciones = map(x -> función_evaluación(x), generación)
    
    # Cálculo de valores auxiliares 
    M = floor(Int, numero_cromosomas_por_generación/2)
    numero_cruces = round(Int, probabilidad_cruce* numero_cromosomas_por_generación/2)
    parejas_a_cruzar = randperm(1:M)[1:numero_cruces]
    indices_cruce = [
        [2*i-1, 2*i] for i in parejas_a_cruzar
    ]
    evaluaciones = numero_cromosomas_por_generación

    while evaluaciones < evaluaciones_máximas_FE
        # Paso 1: Selección (torneo binario)
        índices_seleccionados = TorneoBinario(evaluaciones, numero_cromosomas_por_generación)
        # TODO: te has quedado por aquí (probablemente por el paso 2)
    end
    
end
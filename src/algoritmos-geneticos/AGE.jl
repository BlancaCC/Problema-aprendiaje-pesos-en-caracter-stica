##################################
# ALGORITMO GENÉTICO GENERALISTA 
##################################
using Random

include("generar-cromosoma.jl")
include("torneo-binario.jl")
include("../utils/distancias.jl")
include("../utils/funcion-objetivo.jl")
"""
    AuxCrucePorIndices(i,j,g, FunciónCruce)
Función auxiliar para ahorrarse el cruce si i==j
"""
function AuxCrucePorIndices(i,j,g, FunciónCruce)
    if i == j 
        return [g[i], g[i]]
    else 
        return FunciónCruce(g[i], g[j])
    end
end
"""
    AGE(   evaluaciones_máximas_FE, 
            numero_cromosomas_por_generación, 
            probabilidad_cruce,
            probabilidad_mutación, 
            tamaño_cromosoma, 
            función_evaluación, 
            función_cruce,
            función_mutación)  
    Algoritmo genético generacional, tras las iteraciones convenientes devuelve el cromosoma mejor y su función de valuación 
"""
function AGE(   evaluaciones_máximas_FE, 
                numero_cromosomas_por_generación, 
                # probabilidad_cruce, siempre es 1
                probabilidad_mutación,  
                tamaño_cromosoma, 
                función_evaluación, 
                función_cruce,
                función_mutación)

    # Generamos la primera generación 
    generación = [GeneraCromosoma(tamaño_cromosoma, 0.1) for i in 1:numero_cromosomas_por_generación]
    evaluaciones_función_evaluación = map(x -> función_evaluación(x), generación)
    
    # Variable que acumula el número de evaluaciones de la función de evaluación 
    evaluaciones = numero_cromosomas_por_generación
    # Array que contendrá a los elementos seleccionados
    Seleccionados = generación
    while evaluaciones < evaluaciones_máximas_FE
        
        # Paso 1: Selección (torneo binario)
        índice_seleccionado1 = TorneoBinarioEntreDos(evaluaciones_función_evaluación, numero_cromosomas_por_generación)
        índice_seleccionado2 = TorneoBinarioEntreDos(evaluaciones_función_evaluación, numero_cromosomas_por_generación)

        # Paso 2: Cruce 
        Seleccionados = 
            AuxCrucePorIndices(
                índice_seleccionado1,
                índice_seleccionado2,
                generación,
                función_cruce
        )  
        # Paso 3: Mutación 
        println("tipo $(typeof(Seleccionados))Seleccionados $(Seleccionados)")
        for i in 1:2
            if(rand()< probabilidad_mutación)
                Seleccionados[i] = función_mutación(Seleccionados[i])
            end
        end
        # Paso 4: Reemplazo 
        # Sustituimos los dos peores cromosomas por los dos nuevos 
        índice_peor_1 = argmin(evaluaciones_función_evaluación)
        # para que no vuelva a cogerlo, lo ponemos al valor máximo
        evaluaciones_función_evaluación[índice_peor_1] = 100
        índice_peor_2 = argmin(evaluaciones_función_evaluación)

        # actualizamos los cromosomas 
        generación[índice_peor_1] = Seleccionados[1]
        generación[índice_peor_2] = Seleccionados[2]
        # y su valor de evaluación
        
        
        evaluaciones_función_evaluación[índice_peor_1] = función_evaluación(generación[índice_peor_1])
        evaluaciones_función_evaluación[índice_peor_2] = función_evaluación(generación[índice_peor_2])

        evaluaciones += 2
    end

    # Devolvemos el mejor cromosoma encontrado
    índice_mejor = argmax(evaluaciones_función_evaluación)
    evaluación_mejor = evaluaciones_función_evaluación[índice_mejor]
    mejor_cromosa = generación[índice_mejor]
    return mejor_cromosa, evaluación_mejor  
end

function AGE_LearnerOneNN(data::Matrix{<:Real},labels, 
        evaluaciones_máximas_FE, 
        numero_cromosomas_por_generación, 
        probabilidad_cruce,
        tamaño_cromosoma, 
        función_cruce,
        función_mutación)
     # Creamos función objetivo 
    a = 0.5
    umbral_tasa_reduccion = 0.1
    función_evaluación = CrearFuncionObjetivo(data, labels, a, umbral_tasa_reduccion )
    
    # Buscamos pesos de acorde al algoritmo AGG
    w, f_w = AGE(evaluaciones_máximas_FE, 
        numero_cromosomas_por_generación, 
        probabilidad_cruce,
        tamaño_cromosoma, 
        función_evaluación, 
        función_cruce,
        función_mutación)
    return WeightedLearnerEuclideanOneNN(w, data, labels), f_w, w

end
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
        return g[i], g[i]
    else 
        return FunciónCruce(g[i], g[j])
    end
end
"""
    AGG(   evaluaciones_máximas_FE, 
            numero_cromosomas_por_generación, 
            probabilidad_cruce,
            probabilidad_mutación, 
            tamaño_cromosoma, 
            función_evaluación, 
            función_cruce,
            función_mutación)  
    Algoritmo genético generacional, tras las iteraciones convenientes devuelve el cromosoma mejor y su función de valuación 
"""
function AGG(   evaluaciones_máximas_FE, 
                numero_cromosomas_por_generación, 
                probabilidad_cruce,
                probabilidad_mutación, 
                tamaño_cromosoma, 
                función_evaluación, 
                función_cruce,
                función_mutación)
    # Generamos la primera generación 
    generación = [GeneraCromosoma(tamaño_cromosoma, 0.1) for i in 1:numero_cromosomas_por_generación]
    evaluaciones = map(x -> función_evaluación(x), generación)
    
    # --- Cálculo de valores auxiliares ---
    # Mitad población 
    M = floor(Int, numero_cromosomas_por_generación/2)
    ### Cruce 
    # Número de parejas a cruzar
    numero_cruces = round(Int, probabilidad_cruce* numero_cromosomas_por_generación/2)
    parejas_a_cruzar = randperm(1:M)[1:numero_cruces]
    # Índices de las parejas que se van a cruzar 
    # TODO: Aquí hay un error posiblemente causado por el formato que devuelven las permutaciones
    índices_cruce = [
        [2*i-1, 2*i] for i in parejas_a_cruzar
    ]
    ### Mutación 
    cantidad_cromosomas_a_mutar = round(Int, probabilidad_mutación* numero_cromosomas_por_generación)
    índices_a_mutar = randperm(1:M)[1:cantidad_cromosomas_a_mutar]

    # Variable que acumula el número de evaluaciones de la función de evaluación 
    evaluaciones = numero_cromosomas_por_generación
    # Array que contendrá a los elementos seleccionados
    Seleccionados = generación
    while evaluaciones < evaluaciones_máximas_FE
        # Paso 1: Selección (torneo binario)
        índices_seleccionados = TorneoBinario(evaluaciones, numero_cromosomas_por_generación)

        # Paso 2: Cruce 
        Seleccionados = [
            AuxCrucePorIndices(
                índices_seleccionados[v[1]],
                índices_seleccionados[v[2]],
                generación,
                función_cruce
            )
            for v in índices_cruce
        ]

        # Paso 3: Mutación 
        for i in índices_a_mutar
            Seleccionados[i] = función_mutación(Seleccionados[i])
        end
        # Paso 4: Reemplazo 
        generación = Seleccionados # Por tratarse de algoritmo generalista se reemplaza totalmente la población
        evaluaciones = map(x -> función_evaluación(x), generación)
        evaluaciones += numero_cromosomas_por_generación
    end

    # Devolvemos el mejor cromosoma encontrado
    índice_mejor = argmax(evaluaciones)
    evaluación_mejor = evaluaciones[índice_mejor]
    mejor_cromosa = generación[índice_mejor]
    return mejor_cromosa, evaluación_mejor  
end

function AGG_LearnerOneNN(data::Matrix{<:Real},labels, 
        evaluaciones_máximas_FE, 
        numero_cromosomas_por_generación, 
        probabilidad_cruce,
        probabilidad_mutación, 
        tamaño_cromosoma, 
        función_cruce,
        función_mutación)
     # Creamos función objetivo 
    a = 0.5
    umbral_tasa_reduccion = 0.1
    función_evaluación = CrearFuncionObjetivo(data, labels, a, umbral_tasa_reduccion )
    
    # Buscamos pesos de acorde al algoritmo AGG
    w, f_w = AGG(evaluaciones_máximas_FE, 
        numero_cromosomas_por_generación, 
        probabilidad_cruce,
        probabilidad_mutación, 
        tamaño_cromosoma, 
        función_evaluación, 
        función_cruce,
        función_mutación)
    
    return WeightedLearnerEuclideanOneNN(w, data, labels), f_w, w

end
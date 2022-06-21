using Infinity
include("../utils/distancias.jl")
"""
    RELIEF(data::Matrix{<:Real}, labels)
Algoritmo greedy para determinar el peso W
"""
function RELIEF(data::Matrix{<:Real}, labels)
    dimensiones = size(data)
    # Calculamos tabla de distancias y si son amigos o enemigos 
    distancias = Dict()
    for (i,fila) in enumerate(eachrow(data))
        for j in (i+1):dimensiones[1]
            distancias[(i,j)] =(EuclideanDistance(fila, data[j, :]), labels[i]==labels[j])
        end
    end

    # Calculamos tabla de distancias y si son amigos o enemigos 
    distancia_enemigo = ∞
    indice_enemigo = 0
    distancia_amigo = ∞
    indice_amigo = 0

    w = zeros(dimensiones[2])
    for i in 1:dimensiones[2]
        for j in (i+1):dimensiones[2]
            # vemos si es amigo 
            if distancias[(i,j)][2] == true
                if distancias[(i,j)][1] < distancia_amigo
                    distancia_amigo = distancias[(i,j)][1]
                    indice_amigo = j
                end
            else 
                if distancias[(i,j)][1] < distancia_enemigo
                    distancia_enemigo = distancias[(i,j)][1]
                    indice_enemigo = j
                end
            end
        end
        for j in 1:i-1
            # vemos si es amigo 
            if distancias[(j,i)][2] == true
                if distancias[(j,i)][1] < distancia_amigo
                    distancia_amigo = distancias[(j,i)][1]
                    indice_amigo = j
                end
            else
                if distancias[(j,i)][1] < distancia_enemigo
                    distancia_enemigo = distancias[(j,i)][1]
                    indice_enemigo = j
                end
            end
        end
        if(indice_amigo != 0)
            w = w  + map(abs, data[i, :] - data[indice_amigo, :])
        end 
        if(indice_enemigo != 0)
            w = w + map(abs,data[i, :] - data[indice_enemigo, :])
        end
    end
    w = map(x-> max(0,x), w)
    w = w / maximum(w)
    return w
end

function RELIEF_LearnerOneNN(data::Matrix{<:Real}, labels)
    # Creamos función objetivo 
    a = 0.5
    umbral_tasa_reduccion = 0.1
    F = CrearFuncionObjetivo(data, labels, a, umbral_tasa_reduccion )

    # Buscamos pesos de acorde al algoritmo Greedy
    w = RELIEF(data, labels)

    return WeightedLearnerEuclideanOneNN(w, data, labels), F(w), w
end
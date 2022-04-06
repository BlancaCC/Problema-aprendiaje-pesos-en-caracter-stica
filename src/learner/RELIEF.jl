import "../utils/distancias.jl"
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
        for j in 1:i-1
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
        for j in (i+1):dimensiones[2]
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
        w = w + abs(data[i, :] - data[indice_enemigo, :]) + abs(data[i, :] - data[indice_amigo, :])
    end
    w = map(x-> max(0,x), w)
    w = w / maximum(w)

    return w
end
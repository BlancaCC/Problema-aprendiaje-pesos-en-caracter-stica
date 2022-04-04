export OneNN

using Infinity
"""
    One-NN(x, dist, data, labels)
    Devuelve la clase a la que clasifica x
    a partir del vecino más cercano dentro del conjunto de datos.
"""
function OneNN(x, dist, data, labels)
    distanciaMinima = ∞
    clase = nothing 
    index = 1
    for element in eachrow(data)
        d = dist(element, x)
        if d < distanciaMinima
            distanciaMinima = d 
            clase = labels[index]
        end
        index += 1
    end
    return clase 
end

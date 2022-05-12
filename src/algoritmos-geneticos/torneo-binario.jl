####################################
# Torneo binario
###################################

"""
    TorneoBinario(generación, tamaño)
Devuelve `tamaño` índices  ganadores de cada enfrentamiento. 
"""
function TorneoBinario(evaluación_generación, tamaño)
    índices_ganadores = zeros(Int, tamaño)
    for n in 1:tamaño
        # Índices a enfrentar
        i = rand(1:tamaño)
        j = rand(1:tamaño)
        while j==i
            j = rand(1:tamaño)
        end
        # guardamos el índice del mejor 
        índices_ganadores[n] = evaluación_generación[i] < evaluación_generación[j] ? j : i
    end
    
    return índices_ganadores  
end
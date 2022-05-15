##################################
# Operador de cruce  por media ponderada
##############################
using Random


"""
    BLX(C1, C2)
Operador de cruce por ponderación 
Genera dos hijos 
"""
function MediaPonderada(C1, C2)
    a1 = rand() # valor entre cero y 1 
    a2 = rand() # valor entre cero y 1
    return a1*C1 + (1-a1)*C2, a2*C1 + (1-a2)*C2
end
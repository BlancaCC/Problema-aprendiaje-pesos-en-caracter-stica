##################################
# Operador de cruce  BLX-alpha
##############################
using Random


"""
    BLX(C1, C2, 𝛂)
Operador de cruce BLX, dados dos cromosomas 
devuele dos descencientes. 
Si C1 == C2 entoneces el cruce es la identidad 
"""
function BLX(C1, C2, alpha=0.3)
    l = length(C1)
    H = Array{Float64, 2}(undef, 2, l)
    for j in 1:l
        c_max = maximum([C1[j], C2[j]])
        c_min = minimum([C1[j], C2[j]])
        I = c_max - c_min
        # auxiliales
        longitud_intervalo = I + 2*I* alpha 
        for i in 1:2
            H[i,j] = min(1.0,max(0,rand()*longitud_intervalo + (c_min-I*alpha)))
        end
    end
    return H[1,:], H[2,:]
end
##################################
# Operador de cruce  BLX-alpha
##############################
using Random


"""
    BLX(C1, C2, 𝛂)
Operador de cruce BLX, dados dos cromosomas 
devuele dos descencientes. 
"""
function BLX(C1, C2, alpha)
    l = length(C1)
    H = Array{Float64, 2}(undef, 2, l)
    for j in 1:l
        c_max = maximum([C1[j], C2[j]])
        c_min = minimum([C1[j], C2[j]])
        I = c_max - c_min
        # auxiliales
        longitud_intervalo = 3* I* alpha 
        for i in 1:2
            H[i,j] = rand()*longitud_intervalo + c_min-I*alpha
        end
    end
    return H[1,:], H[2,:]
end
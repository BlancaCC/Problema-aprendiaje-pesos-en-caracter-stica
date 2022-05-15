######################################
### Algoritmo de búsqueda local
#### Es una modificación del presentado en algoritmos 
# de búsqueda, que el que se hizo en la P1 generaba el vector 
# aleatorio mientras que ahora se parte del algoritmo genético
########################################

include("../algoritmos-busqueda/generar-vecino.jl")

"""
PrimeroMejor(
    evaluaciones_maximas_funcion_objetivo::Int, 
    Fun_evalun_eval
    )::Vector{<:Real}

Devuelve mejor vector de peso encontrando de acorde a función 
de evaluación `Fun_eval`
"""
function PrimeroMejor(w, 
    evaluaciones_maximas_funcion_objetivo::Int,
    Fun_eval)::Vector{<:Real}
    evaluaciones = 0
    Fun_eval_w = Fun_eval(w)
    indice::Int = 1 
    while evaluaciones < evaluaciones_maximas_funcion_objetivo
        w_n = GenNeighbourhoodIesimo(w,0, 0.3, indice)
        
        Fun_eval_w_vecino = Fun_eval(w_n)

        if(Fun_eval_w < Fun_eval_w_vecino)
            w = w_n
            Fun_eval_w = Fun_eval_w_vecino
        end
   
        evaluaciones += 1
    end
    return w
end
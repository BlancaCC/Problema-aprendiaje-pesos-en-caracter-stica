export CrearFuncionObjetivo

include("validation.jl")
include("../learner/euclidean-1-NN.jl")

using .ModuleValidation

"""
CrearFuncionObjetivo(datos, etiquetas, a, umbral_tasa_reduccion::Real)

    Devuelve una función  `f(w)` para analizar la bondad de w en base al algoritmo de clasificación 
    1-NN y la reducción que posea.
    Argumentos: 
    `a` Coeficiente de la combinación convexa que determina la bondad
    f(w)= a*tasa aciertos + (1-a) tasa de reducción 

"""
function CrearFuncionObjetivo(datos, etiquetas, a::Real, umbral_tasa_reduccion::Real)

    function FuncionObjetivo(w::Vector{<:Real})::Real
        # Calculamos tasa de clasificación [0,100]
        learner(d,l)=WeightedLearnerEuclideanOneNN(w,d,l)
        accuracy = LeaveOneOut(datos, etiquetas, learner)
        
        # Calculamos tasa de reducción valor entre [0,100]
        tasa_reducion = 100*sum(
            map(x-> (x < umbral_tasa_reduccion) ? 0 : 1, w)
            )/length(w)
        # Evaluación combinación de ambas
        return a*accuracy + (1-a)*tasa_reducion
    end

    return FuncionObjetivo
end 
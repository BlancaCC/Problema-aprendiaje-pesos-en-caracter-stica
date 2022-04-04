export EuclideanDistance
export WeightedEuclideanDistance

EuclideanDistance(x,y) = sqrt(sum(map(x-> x^2, x.-y)))
_weightedSquare(x,w)=w*x^2
WeightedEuclideanDistance(x,y,w) = sqrt(sum(map(_weightedSquare,(x.-y), w)))


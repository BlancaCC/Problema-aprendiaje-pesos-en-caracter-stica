include("../../naive-classifiers/constant.jl")
include("../../utils/validation.jl")

data = [-1 0; 1 1; -1 -3; 1 -2; 9 -1; 1 2; 10 20]
class = ['-', '+',  '-',   '-',  '-', '+' , '+' ]
class = [-1,   1,    -1,    -1,   -1,   1,    1]
file_name = "src/test/VerboseValidationResults.test.csv"
VerboseCrossValidation(data, class, 3, ConstantLearnerVerbose, file_name)
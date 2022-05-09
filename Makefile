all: compile

result_p1: #install-julia-packages
	julia --project=. src/resultados/1NN.jl 
	julia --project=. --threads 2  src/resultados/Greedy.jl
	julia --project=. --threads 2 src/resultados/Busqueda-Local.jl 
compile:
	cd doc/ && latexmk -shell-escape -pdf memoria_1.tex

clean:
	find . -name "*.aux" -type f -delete
	cd doc/ && rm -f *.toc *.out *.lot *.log  *.ind *.ilg *.fls *.fdb_latexmk *.brf *.blg *.bbl *.idx *.lof *.bcf *.xml *.gz
# Corrector ortográfico
spell:
	./scripts/spell-check.sh

install-spell:
	sudo apt-get install aspell aspell-es aspell-en

sort:
	./scripts/order-dictionary.py

lazy: 
	./scripts/lazy-spell-check.sh

workflow-spell: install-spell spell

# Test code 
install-julia-packages:
	julia --project=. scripts/julia_pkg_instalations.jl
	
test-library:
	julia --project=. src/test/OneNN.test.jl  
	julia --project=. src/test/distancias.test.jl
	julia --project=. src/test/datos.test.jl
	julia --project=. src/test/generar-vecinos.test.jl
	julia --project=. src/test/funcion-objetivo.test.jl
	julia --project=. --threads 3 src/test/VerboseValidation.test.jl
	julia --project=. src/test/Relief.test.jl

test-library-workflow: test-library


## test en general 
test: spell 


	
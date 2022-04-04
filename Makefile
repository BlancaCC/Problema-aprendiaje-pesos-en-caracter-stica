all: compile

result: 
	julia src/resultados/1NN.jl 
	julia src/resultados/Busqueda-Local.jl 
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
	julia scripts/julia_pkg_instalations.jl
	
test-library:
	julia src/test/OneNN.test.jl  
	julia src/test/distancias.test.jl
	julia src/test/datos.test.jl
	julia src/test/generar-vecinos.test.jl
	julia src/test/funcion-objetivo.test.jl
	julia src/test/VerboseValidation.test.jl

test-library-workflow: install-julia-packages test-library


## test en general 
test: spell 


	
all: compile

result_p2_geneticos:
	julia --project=. --threads 2 src/resultados/Genéticos/AGG/BLX/AGG_BLX.jl
	julia --project=. --threads 2 src/resultados/Genéticos/AGG/Media/AGG_Media.jl 
	julia --project=. --threads 2 src/resultados/Genéticos/AGE/BLX/AGE_BLX.jl 
	julia --project=. --threads 2 src/resultados/Genéticos/AGE/Media/AGE_Media.jl 

result_p2_memeticos:
	julia --project=. --threads 2 src/resultados/Meméticos/AM-10-1/AM-10-1.jl
	julia --project=. --threads 2 src/resultados/Meméticos/AM-10-01/AM-10-01.jl
	julia --project=. --threads 2 src/resultados/Meméticos/AM-10-01-mej/AM-10-01-mej.jl 
 
result_p1: 
	julia --project=. src/resultados/1NN/1NN.jl 
	julia --project=. --threads 2  src/resultados/Greedy/Greedy.jl
	julia --project=. --threads 2 src/resultados/BL/Busqueda-Local.jl 
compile:
	cd doc/ && latexmk -shell-escape -pdf P2_Blanca_Cano_Camarero.tex

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
	
test-library-P1:
	julia --project=. src/test/P1/OneNN.test.jl  
	julia --project=. src/test/P1/distancias.test.jl
	julia --project=. src/test/P1/datos.test.jl
	julia --project=. src/test/P1/generar-vecinos.test.jl
	julia --project=. src/test/P1/funcion-objetivo.test.jl
	julia --project=. --threads 3 src/test/P1/VerboseValidation.test.jl
	julia --project=. src/test/P1/Relief.test.jl

# Test de la biblioteca P-2
t:
	julia --project=. src/test/P2/operadores_cruce.test.jl

test-library-workflow: test-library-P1


## test en general 
test: spell 


	
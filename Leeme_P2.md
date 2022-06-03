# Práctica 2  

## Ejecución
La práctica ha sido implementada en el lenguaje de programación julia y para ejecutar alguno de los experimentos basta con escribir en el directorio raíz: 

`make result_p2_geneticos`
`make result_p2_memeticos`

Estos comando ejecutarán los respectivos algoritmos de la carpeta del directorio resultados. Al completarse la ejecución, mostrará en pantalla los resultados y además generará un fichero csv en la carpeta correspondiente. 

Si desea ejecutar un programa concreto, con cierto número de hebras y sobre unos datos, bastará con escribir algo como:
 
`julia --project=. --threads 2 src/resultados/Genéticos/AGG/BLX/AGG_BLX.jl 3`

Que lanzará el experimento relacionado con los algoritmos genético generacionales, con dos hebras y la base de datos 3 (que se corresponde a la de Spetf-heart). 

Si no se introduce ningún argumento al final se calcularán todas las bases de datos. 

## Estructura de los archivos  

El código concerniente a esta práctica se encuentra desarrollado en:  

1. `src/algoritmos-geneticos`
2. `src/algoritmo-memetico`
3.`src/resultados` donde podrá encontrar las tablas csv generadas.
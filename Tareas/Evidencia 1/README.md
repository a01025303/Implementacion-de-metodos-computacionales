<b> Integrantes del Equipo: </b><br>
Andreína Sanánez, A01024927 <br>
Ana Paula Katsuda, A01025303 <br>

# Actividad Integradora - Resaltador de Sintaxis

## Instrucciones de uso del Programa
  Para utilizar el código anterior, en el mismo directorio se deben de contar con los siguientes archivos:
- `main.exs`
- `index.html`
- `token_colors.css`
- `json_example.json`

Para correrlo ejecute el siguiente comando en su terminal estando en dicho directorio.<br>
`> iex main.exs`<br>
`iex(1)> Tfiles.json_html("json_example.json", "index.html")`<br>

Una vez realizado lo anterior,  para visualizar el resaltado de la sintaxis abra el archivo “index.html” en su buscador de preferencia.

## Análisis de la Solución
  En el presente reporte se describe y analiza a profundidad la solución implementada para la realización de un resaltador de sintaxis mediante el lenguaje de programación funcional Elixir así como el uso de expresiones regulares. Adicionalmente, es relevante mencionar que dicho resaltador evalúa la sintaxis del formato de texto JSON (JavaScript Object Notation) y muestra las misma mediante un documento HTML. Específicamente, la solución planteada para el resaltador de sintaxis toma en consideración los siguientes elementos:
- **Dígitos:** se resaltan números enteros, flotantes y exponenciales.
- **Cadena de caracteres (strings):** se resaltan las cadenas de caracteres encapsuladas entre comillas correspondientemente. 
- **Objetos:** se resalta el nombre del par el cual se encuentra encapsulado entre comillas y seguido de dos puntos.
- **Puntuación:** se resaltan signos de puntuación como corchetes, llaves,  comas, dos puntos.
- **Palabras reservadas:** se resaltan palabras reservadas como `true`, `false`, `null`.

  Ahondando en la solución planteada para implementar un resaltador de sintaxis en Elixir, existen diversas características a mencionar. El código, visto de una manera general, consta de dos funciones. La primera, json_html, lee el archivo json, lo convierte en un `stream()` e implementa la función regex para escribir los resultados en un archivo html. La segunda, `regex()`, evalúa las expresiones regulares correspondientes a cada “llave” o “token” y reemplaza lo encontrado por expresiones que incluyen el formato necesario para un documento html. 

  De lo anterior, es relevante mencionar que el uso de `stream()` es de gran ayuda puesto a que permite la lectura de una línea a la vez, haciendo el proceso de evaluación de los contenidos del json más simple. De igual manera, el uso de “cond” permite la integración de las posibles llaves, evaluándolas y utilizando recursión para repetir dicha evaluación en otros casos. Aquí, se vuelve evidente el importante rol que toma la recursión en el algoritmo planteado y en un funcionamiento efectivo. 

  En el caso de la evaluación de expresiones regulares y la adición de texto al html, se utilizaron las funciones `run()` y  `replace()`. En estas condiciones, `run()` sirve para evaluar si se encontró la expresión, ya que de no encontrarse, la función regresa el valor “nil”. Una vez que se encontró dicha expresión, se utiliza `replace()` para sustituir los valores por un texto completo de html y posteriormente, escribir dicho texto. 

  En cuanto a las implicaciones que radican de la solución descrita anteriormente, es relevante analizar los aspectos positivos y negativos que esta conlleva. Por un lado, el hecho de utilizar el método `replace()` facilita en gran medida lograr un código limpio y simple de comprender. No obstante, al estar reemplazando el archivo .json original con las líneas correspondientes de html ocasiona que las expresiones regulares sean un tanto más complicadas, ya que estas deben de tomar las consideraciones adicionales que surgen con el texto que ya fue sustituido. Por lo mismo, es posible decir que el mantenimiento del código como tal es notablemente factible dada su sencilla estructura, sin embargo la complejidad de lo anterior vendría de la modificación de las expresiones regulares para identificar los cambios que sean necesarios.

  Por otra parte, referente a la complejidad temporal del programa, se vuelve evidente que el componente con mayor carga es el `replace()` ya que éste es el encargado de realizar las sustituciones; es evidente que, al aumentar el tamaño del archivo, el `replace()` tardará más en hacer las sustituciones correspondientes. Asimismo, es notorio que cada vez que se evalúe el `replace()`, se estará evaluando una línea más larga debido a la implementación de reemplazos anteriores (que en este caso, resultan en algo más largo que los valores iniciales). A la vez, no borrar lo que ya está reemplazado, aumenta la complejidad temporal, ocasionando que siempre que se ejecute el `replace()` se evalúe toda la línea nuevamente.

  Finalmente, a pesar de las implicaciones que se pueden encontrar en cuanto a complejidad temporal, el código es suficientemente eficiente y rápido en cuanto a su funcionalidad de resaltar sintaxis de archivos `.json` con tamaños considerables como aquellos que se muestran en los ejemplos.


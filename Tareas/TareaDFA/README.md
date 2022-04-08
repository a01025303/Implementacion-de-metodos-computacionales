# Manual del Usuario

El presente manual tiene como objetivo profundizar en el funcionamiento del código para un Autómata DFA. En este caso, se especificará la manera en la que se debe correr, los lenguajes utilizados y las salidas del programa. 

## Lenguaje
En este caso, el lenguaje utilizado es Racket. Este lenguaje es comúnmente utilizado para la creación de otros lenguajes e incluso para programas comerciales. 

### Qué instalar para que funcione
Para poder utilizar Racket, es necesario primero descargarlo en el siguiente link: https://download.racket-lang.org/releases/8.4/.

Existen distintas opciones en cuanto a esto dependiendo del sistema operativo con el que se cuente. Para descargarlo, es suficiente con darle click al instalador correspondiente y seguir las instrucciones del instalador. 

## Cómo correr el programa 
Para correr el programa, es necesario escribir lo siguiente en la terminal que se esté utilizando (linux): `racket DFA.rkt`. Especificamente en este caso, se muestran los casos de prueba que ya están incluidos en el programa.

Si se quisiera interactuar con el programa, añadiendo una cadena distinta a la función, se debe escribir en el siguiente formato: `racket -it DFA.rkt` (se agrega un tag -it entre el identificador racket y el nombre del archivo). Posteriormente, dentro del "interactive shell", es necesario escribir: `(arithmetic-lexer "cadena a evaluar")`.

En caso de querer correr otro programa, simplemente se utiliza la parabra reservada racket y se agrega el nombre del archivo (que tiene que terminar con la extensión .rkt). 


## Algoritmo y explicación
En cuanto al algoritmo, es necesario especificar las consideraciones que se tienen para cada token que se lee. En primer lugar, los tipos de token considerados son:  

* enteros
* flotantes (reales)
* operadores (suma, resta, asignación, multiplicación, división, potencia)
* identificadores (variables)
* símbolos especiales (paréntesis que abre y cierra ())

En este caso, el programa no está adecuado para la identificación de comentarios ni para la identificación de espacios al principio o al final de la expresión completa. 

Los diagramas realizados para definir la lógica del programa, se encuentran en esta carpeta del repositorio de github con los siguientes nombres:
* Tabla de transición: `TransitionTable.png`
* Finite State Machine Diagram: `automata.svg`

En cuanto a los casos específicos de las variables y los valores numéricos, se recalca que las variables solamente pueden comenzar con una letra y pueden tener adentro letras, _ y dígitos. Asimismo, los números pueden ser exponentes.

## Lo que se obtiene de salida
La salida del programa es una lista que contiene pares en el formato (token, valor). Es decir, se especifica qué tipo de token es (ya sea variable, entero, etc) y luego se escribe el valor correspondiente a dicho token (el valor que contribuyó a identificarlo).

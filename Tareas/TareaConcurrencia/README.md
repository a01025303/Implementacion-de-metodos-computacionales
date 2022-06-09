Andreína Sanánez, A01024927 <br>
Ana Paula Katsuda, A01025303 <br>
Implementación de Métodos Computacionales <br>
10 de Junio del 2022 <br>
<br>
<br>
<br>


# Actividad 5.2 Programación Paralela y Concurrente   

## **Funcionamiento del Programa**

El presente reporte describe la solución provista mediante el lenguaje de programación Elixir, para calcular la suma de todos los números primos referentes a cierto límite. Esto con el principal objetivo de analizar la diferencia de eficiencia que se obtiene al resolver la problemática de forma secuencial en comparación con una implementación en paralelo. Dicho esto, para lo anterior se implementaron las siguientes funciones.
<br>

* **`is_prime(n)`**: esta función es la base de las demás funciones implementadas, y a partir de un número que recibe como argumento, esta regresa verdadero si el número es primo y falso de lo contrario. Para ello se utiliza un algoritmo donde se evalúa si cada número desde el 2 hasta la raíz cuadrada del mismo es divisible, así evitando evaluar los números restantes hasta el límite que no son necesarios.

* **`sum_primes(lim)`**: está es la función que a partir de un límite dado, calcula la suma de todos los números primos de forma secuencial, es decir evaluando si cada número es primo en cada iteración recursiva. Para ello, se utiliza la función anterior is_prime(n).

* **`sum_primes range(start, finish)`**: esta función es una ligera modificación de la función anterior que en lugar de recibir un límite permite calcular la suma de los primos dentro de un rango determinado por los parámetros de inicio y fin del mismo.

* **`sum_primes_parallel(lim, threads)`**: esta función es la implementación en paralelo de la función anterior “sum_primes range(start, finish)”. De forma más específica, esta permite que el usuario seleccione el número de “threads” a utilizar, por lo que a partir de ello se dividen equitativamente la cantidad de números a sumar por cada “thread” en paralelo, y de ser el caso donde dicha división no sea exacta, se le agrega al primer thread (que realiza las sumas menos extensas) el rango de números faltantes.
<br>
<br>

## **Análisis de Tiempo y Speedup**

Al correr el presente código considerando tanto la manera secuencial como la manera paralela (usando distintos “threads”) se obtienen los siguientes tiempos: <br>
<br>
<center><img src=time.png></center>
<br>

El primer tiempo corresponde a la solución secuencial del problema. Es posible notar que ésta tarda aproximadamente 15 segundos. En comparación, el segundo tiempo utiliza la implementación paralela considerando 4 “threads”, lo que disminuye el tiempo de ejecución notoriamente (de 15 segundos a 5 segundos respectivamente). 

Tomando en consideración la cantidad de “threads” utilizados, es evidente que el tiempo al tener 6 threads disminuye casi a la mitad que al usar 4 “threads”. Aquí se observa que la cantidad de “threads” tiene un impacto importante en el tiempo de ejecución ya que una mayor cantidad de éstos, implica que cada uno tiene que procesar menos cosas. Al estarlo haciendo de manera paralela, esto contribuye a disminuir significativamente el tiempo. 

Finalmente, al examinar el último tiempo que corresponde a la llamada de la implementación paralela, dejando el número de “threads” a la cantidad reconocida por la computadora, es posible percibir que el tiempo disminuye aún más. En este caso, la cantidad de “threads” reconocida por la computadora es de 12, por lo que resulta lógico que el tiempo sea pequeño. 

Lo anterior demuestra el impacto que tiene hacer uso de la programación paralela en la eficiencia de tiempo de un programa. Dividir tareas y hacerlas de manera paralela no sólo aprovecha el poder computacional que se tiene gracias a los múltiples núcleos de las CPUs, sino que ahorra tiempo de ejecución (que puede tener una gran importancia en diversos contextos) eficientizando un programa.




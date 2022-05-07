# Functional programming practice with elixir
# Andreína Sanánez (A01024927) and Ana Paula Katsuda (A01025303)


# Create module for insertions 
defmodule Inserting do
    # 1.  La función insert toma dos entradas: un número n y una lista lst que contiene
    # números en orden ascendente. Devuelve una nueva lista con los mismos elementos de
    # lst pero con n insertado en su lugar correspondiente.

    # Create insert function and its tail function 
    def insert(n, lst), do: do_insert(lst, [], n)
    # Recursive case --> when head is biggen than the number
    defp do_insert([head | tail], resLst, n) when n < head, 
        # Return a new list with n inserted before the head (which is bigger)
        do: Enum.reverse(resLst) ++ [n, head|tail]
    # Recursive case --> while not encountering a head bigger than n
    defp do_insert([head | tail], resLst, n), 
        # Iterate through list, adding numbers to the result and maintaining tail
        do: do_insert(tail, [head|resLst], n)
    # Recursive case --> if the list has ended and a bigger head was never found
    defp do_insert([], resLst, n), 
        # Return the result list, adding n to the end
        do: Enum.reverse([n|resLst])


    # 2. La función insertion-sort toma una lista desordenada de números como 
    # entrada y devuelve una nueva lista con los mismos elementos pero en orden 
    # ascendente. Se debe usar la función de insert definida en el ejercicio
    # anterior para escribir insertion-sort. No se debe utilizar la función sort 
    # o alguna similar predefinida.

    # Create insertion_sort function and its tail function
    def insertion_sort(lst), do: do_insertion_sort(lst, [])
    # Recursive case --> when the original list is empty
    defp do_insertion_sort([], resLst), 
        #Return the result list 
        do: resLst
    # Recursive case --> while original list is not empty
    defp do_insertion_sort([head | tail], resLst), 
        # Insert head into sorted position using insert
        # the original list is now the tail
        do: do_insertion_sort(tail, insert(head, resLst))
end

defmodule MyModule do

    # 3. La funcion rotate-left toma dos entradas: 
    # un n ́umero entero n y una lista lst. Devuelve la lista que resulta
    # de rotar lst un total de n elementos a la izquierda. 
    # Si n es negativo, rota hacia la derecha.

    #Start function
    def rotate_left(list, n), 
        do: rotate_recursive(list, n)
        #Left-rotate -> for n positive append head to the tile while n greater than zero
        defp rotate_recursive([head | tail], n) when n > 0 
            do rotate_recursive(tail ++ [head], n-1) end
        #Right-rotate -> for n negative pass last element to indx0 and remove that element from the last indx (while n<0)
        defp rotate_recursive(list, n) when n < 0 
            do rotate_recursive(Enum.drop(Enum.take(list, -1) ++ list, -1), n+1) end
        #When n reaches zero return list
        defp rotate_recursive(list, 0), 
            do: list
        #When the input list is empty return list
        defp rotate_recursive([], _n), 
            do: []



    #10. La funcion encode toma una lista lst como entrada. 
    #Los elementos consecutivos en lst se codifican en listas
    #de la forma: (n e), donde n es el n ́umero de ocurrencias del elemento e   
    
    #Start Function
    def encode(list), 
        do: encode_recursive(list, [], 0)
        #If the first two elements of the list are equal (item,item) the next recursive call increases the counter and discards the lists 1st element                                                     
        defp encode_recursive([item, item | tail], result, count), 
            do: encode_recursive([item | tail], result, count+1)
        #If the first 2 elements of the list are different -> counter restarts to 0 and encoded item is added to the result list 
        defp encode_recursive([item, dif_item | tail], result, count), 
            do: encode_recursive([dif_item | tail], result ++ [[item, count+1]], 0)
        #If the list left has only 1 element -> next iteration is an empty list, encoded item is added to the result list
        defp encode_recursive([item | []], result, count), 
            do: encode_recursive([], result ++ [[item, count+1]], 0)
        #If the input list is empty -> return result list in the correct order
        defp encode_recursive([], result, _count), 
            do: result
end

# Tests for insert
IO.inspect Inserting.insert(14, [])
IO.inspect Inserting.insert(4, [5, 6, 7, 8])
IO.inspect Inserting.insert(5, [1, 3, 6, 7, 9, 16])
IO.inspect Inserting.insert(10, [1, 5, 6])

IO.puts ""
# Tests for insertion_sort
IO.inspect Inserting.insertion_sort([])
IO.inspect Inserting.insertion_sort([4, 3, 6, 8, 3, 0, 9, 1, 7])
IO.inspect Inserting.insertion_sort([1, 2, 3, 4, 5, 6])
IO.inspect Inserting.insertion_sort([5, 5, 5, 1, 5, 5, 5])




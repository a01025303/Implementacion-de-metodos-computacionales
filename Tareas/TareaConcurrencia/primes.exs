# Program that compares the efficiency of calculating the sum of
# all prime numbers within a range, with a sequential and a parallel function

# 2022-05-31

# Andreina Sananez / A01024927
# Ana Paula Katsuda / A01025303


defmodule HwPrimes do

    #Function that determines if a number is prime (true) or not (false)
    def is_prime(n) when n < 2, do: false
    def is_prime(n) when n >= 2, do: is_prime_rec(n, 2, :math.sqrt(n), 1)
    
    #If the number was divisible by other number
    defp is_prime_rec(_num, _count, _lim, res) when res == 0, do: false

    #If all numbers where divided and none where divisible
    defp is_prime_rec(_num, count, lim, _res) when count > lim, do: true

    #If not all numbers have been divided yet
    defp is_prime_rec(num, count, lim, _res) when count <= lim, 
        do: is_prime_rec(num, count + 1, lim, rem(num, count))


    #Function that sequentially sums all prime numbers within a limit
    def sum_primes(lim), do: sum_primes_rec(lim, 0, is_prime(lim))

    #If all numbers have been evaluated return result
    defp sum_primes_rec(lim, res, _is_prime) when lim == 0, do: res

    #If current number is prime add to result
    defp sum_primes_rec(lim, res, is_prime) when is_prime, 
        do: sum_primes_rec(lim - 1, res + lim, is_prime(lim - 1)) 

    #If current number is not prime result doesn't change
    defp sum_primes_rec(lim, res, is_prime) when is_prime == false, 
        do: sum_primes_rec(lim - 1, res, is_prime(lim - 1)) 



    #Function that sequentially sums all prime numbers within a range
    def sum_primes_range(start, finish), 
        do: sum_primes_range_rec(start, finish, 0, is_prime(finish))

    #If all numbers have been evaluated return result
    defp sum_primes_range_rec(start, finish, res, _is_prime) when finish < start, 
        do: res

    #If current number is prime add to result
    defp sum_primes_range_rec(start, finish, res, is_prime) when is_prime, 
        do: sum_primes_range_rec(start, finish - 1, res + finish, is_prime(finish - 1)) 

    #If current number is not prime result doesn't change
    defp sum_primes_range_rec(start, finish, res, is_prime) when is_prime == false, 
        do: sum_primes_range_rec(start, finish - 1, res, is_prime(finish - 1)) 



    #Function that sums all prime numbers using parallelism
    def sum_primes_parallel(lim, threads \\ System.schedulers), 
        do: sum_primes_parallel_rec(threads, div(lim, threads), rem(lim, threads))

    #If range division results in an integer
    defp sum_primes_parallel_rec(threads, range, 0) do
        1..threads
        |>Enum.map(&Task.async(fn -> 
        sum_primes_range(1 + (&1 - 1) * range, &1 * range) end))
        
        |>Enum.map(&Task.await(&1))
        |>Enum.sum()
    end

    #If range division has a remainder
    defp sum_primes_parallel_rec(threads, range, rem) do
        1..threads
        |>Enum.map(&Task.async(fn -> 
        sum_primes_range((1 + (&1 - 1) * range) + rem, (&1 * range) + rem) end))

        |>Enum.map(&Task.await(&1))
        |>Enum.sum()
        |>Kernel.+(sum_primes_range(1, rem))

    end
          
end 


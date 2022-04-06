#|
Ana Paula Katsuda, A01025303
Andreína Sanánez, A01024927

Actividad 2.1 Programación funcional, parte 1
|#

;Determine the language to interpret this file
#lang racket

;Provide functions for use in interactive mode
(provide 
fahrenheit-to-celsius 
sign 
roots 
bmi 
factorial 
duplicate 
pow 
fib 
enlist 
positives 
add-list
invert-pairs
list-of-symbols?
swapper
dot-product
average
standard-deviation
replic
binary 
)

;Function 1: Converts from fahrenheit to Celsius
(define (fahrenheit-to-celsius fahrenheit)
    "Convert from fahrenheit to Celsius"
    (/ (* 5 (- fahrenheit 32)) 9))

;Function 2: Indicates the sign of a number (-1 negative, 0 zero, 1 positive)
(define (sign number)
    "Indicate if a number is positive, negative or zero"
    (cond
    [(zero? number) 0] ;evaluate number=0 return 0
    [(> number 0) 1] ;evaluate number > 0 return 1
    [else -1])) ;else return -1

;Function 3: Solves the quadratic formula 
(define (roots a b c)
    "Solves the quadratic formula with coefficients a,b,c "
    (/ (+ (* b -1) (sqrt (- (* b b) (* 4 a c)))) (* 2 a)))

;Function 4: Returns a description (underweight, normal, obese1, obese2, obese3) related to the Body Mass Index (BMI)
(define (bmi weight height)
    "Returns a description related to the Body Mass Index (BMI)"
    
    ;Function that calcualates BMI
    (define varBMI (/ weight (* height height)))

    ;Condition to evaluate the resulting description
    (cond
    [(< varBMI 20) 'underweight] ;evaluate bmi < 20
    [(and (or (> varBMI 20) (= varBMI 20)) (< varBMI 25)) 'normal] ;evaluate 20 <= bmi < 25
    [(and (or (> varBMI 25) (= varBMI 25)) (< varBMI 30)) 'obese1] ;evaluate 25 <= bmi < 30
    [(and (or (> varBMI 30) (= varBMI 30)) (< varBMI 40)) 'obese2] ;evaluate 30 <= bmi < 40
    [(or (> varBMI 40) (= varBMI 40)) 'obese3]) ;evaluate 40 <= bmi   
)

;Function 5: Returns the factorial of a positive integer n (with tail recursion)
(define (tailFactorial n accumulator)
    "Calculates the factorial of a positive integer (tail-recursion)"

    ;Evaluate stop condition and recursion
    (if (= n 0) ; evaluate if n==0
        accumulator ; return accumulator
        (tailFactorial (sub1 n) (* n accumulator)) ;else execute recursive part tailFactorial(n-1, n*a)
    )
)

;Wrapper for the tail recursive function
(define (factorial n)
    "Calculates the factorial of a positive integer"  
    
    ;Accumulator starts with a value of 1 
    (tailFactorial n 1)
)

;Function 6: Generates a new list by duplicating the elements of a given one
(define (tail-duplicate lst duplicateList count)
    "Recursive function that generates a new list by duplicating the elements of a given one"
    
    ;Stop condition -> when length == 0
    (cond
    [(= count (length lst)) duplicateList] ;When count==ListLength all elements have been duplicated

    ;recursive step: lst(argList, append twice element at index count, count+1)
    [else (tail-duplicate lst (append duplicateList (list (list-ref lst count) (list-ref lst count))) (add1 count))] 
    )
)

;Wrapper for the tail-lst function
(define (duplicate lst)
    "Generates a new list by duplicating the elements of a given one"
    
    (tail-duplicate lst '() 0) ; duplicateList starts empty, counter starts at zero
)

;Function 7: Calculates the power of a number "a" to the power of "b"
(define (tail-pow a b accumulator)
    "Recursive function that calculates the power of a number a to the power of b"

    (if (= b 0) 
        accumulator ; Evaluate if b==0 all multiplications where executed and the result is returned
        (tail-pow a (sub1 b) (* accumulator a)) ; else the recursive step takes place (b serves as a counter)
    )
)

;Wrapper for tail-pow function
(define (pow a b)
    "Calculates the power of a number a to the power of b"

    (tail-pow a b 1)
)

;Function 8: takes as argument a positive integer n and returns the corresponding element of the Fibonacci sequence
(define (fib n)
    "Function that receives an index n and returns the corresponding element of the Fibonacci sequence"
     
    (if (or (< n 1) (= n 1))
        n ; if n <= 1 then return n
        (+ (fib (sub1 n)) (fib (- n 2))) ; recursive step where fib(n) = fib(n-1) + fib(n-2)
    )
)

;Function 9: takes a list as an argument and converts each of its elements into a list resulting in a list of lists
(define (tail-enlist lst endList count)
    "Recursive function that from a list converts each of its elements into a list resulting in a list of lists"

    (if (= count (length lst))
        endList ; if count== the list length that means every element has been enlisted -> return endList
        (tail-enlist lst (append endList (list (list (list-ref lst count)))) (add1 count)) ;recursive step: endlist = append the enlisted element corresponding to the index count
    )

)

;Wrapper for tail-enlist
(define (enlist lst)
    "takes a list as an argument and converts each of its elements into a list resulting in a list of lists"

    (tail-enlist lst '() 0) ; endList -> starts empty; count -> starts at zero
)

;Function 10: takes a list of numbers and returns a list only with the positive elements
(define (tail-positives lst endList count)
    "Recursive funtion that takes a list of numbers and returns a list only with the positive elements"

    (if (= count (length lst))
        endList ;when the counter has gone through every element of lst, return endList with all the appended positive numbers 
        (tail-positives lst (if (positive? (list-ref lst count)) (append endList (list (list-ref lst count))) endList) (add1 count)) ;recursive step: endList -> appends current element if positive, increment count by 1
    )
)

;Wrapper for tail-positives function
(define (positives lst)
    "Recursive funtion that takes a list of numbers and returns a list only with the positive elements"

    (tail-positives lst '() 0) ;endList -> starts empty; count -> starts at zero
)

; 11. Function add-list that adds the numbers inside a list
(define (add-list list) ; Define the function 
    (if (zero? (length list)) ; Evaluate if list has elements
        0 ; if it doesn't have elements
        (+ (first list) (add-list (list-tail list 1))))) ; if it has elements, it adds them up using recursion 
; Tests for excercise 11
(add-list '())
(add-list '(2 4 1 3))
(add-list '(1 2 3 4 5 6 7 8 9 10)) 

; 12. Function invert-pairs that invert pair lists within a list
(define (invert-pairs list) ; Define the function 
    (if (zero? (length list)) ; Evaluates if it has elements
        null ; if it doesn't have elements, assign null
        (cons (reverse (first list)) (invert-pairs (list-tail list 1)))) ; if it has elements, reverse each pair using recursion (the first element is dropped in each step)
)
; Tests excercise 12
(invert-pairs '())
(invert-pairs '((a 1) (a 2) (b 1) (b 2)))
(invert-pairs '((January 1)(February 2)(March 3)))

; 13. Function list-of-symbols? identifies if all the elements within a list are symbols
(define (list-of-symbols? list) ; Define function 
    (if (zero? (length list)) ; Evaluate if it has elements 
        true ; If it doesn't have elements, assign true
        (and (symbol? (first list)) (list-of-symbols? (list-tail list 1))) ; Compare each element using recursion (dropping the first element each step)
    )
)
; Tests excercise 13
(list-of-symbols? '())
(list-of-symbols? '(a b c d e))
(list-of-symbols? '(a b c d 42 e))


; 14. Function swapper changes every val1 to val2 and viceversa within a list 
(define (swapper val1 val2 list) ; Define the function
    (if (zero? (length list)) ; Evaluates if it has elements
        null ; If it doesn't have elements, assign null
        (cond ; Evaluate different cases 
            [(eq? (first list) val1) (cons val2 (swapper val1 val2 (list-tail list 1)))] ; case where the number is val1
            [(eq? (first list) val2) (cons val1 (swapper val1 val2 (list-tail list 1)))] ; case where the number is val2
            [else (cons (first list) (swapper val1 val2 (list-tail list 1)))] ; case where the number isn' val1 or val2
        )
    )
)
; Tests excercise 14 
(swapper 1 2 '())
(swapper 1 2 '(4 4 5 2 4 8 2 5 6 4 5 1 9 5 9 9 1 2 2 4))
(swapper 1 2 '(4 3 4 9 9 3 3 3 9 9 7 9 3 7 8 7 8 4 5 6))
(swapper 'purr 'kitty '(soft kitty warm kitty little ball of fur happy kitty sleepy kitty purr purr purr))

; 15. Function to calculate the dot product of the numbers within a list
(define (dot-product list1 list2) ; Define the function
    (if (zero? (length list2)) ; Evaluate if list has elements 
        0 ; if it doesn't have elements, assign 0
        (+ (* (first list1) (first list2)) (dot-product (list-tail list1 1) (list-tail list2 1))) ; Calculate dot product using recursion (dropping the first element of each list)
    )
)
; Tests excercise 15
(dot-product '() '())
(dot-product '(1 2 3) '(4 5 6))
(dot-product '(1.3 3.4 5.7 9.5 10.4) '(-4.5 3.0 1.5 0.9 0.0))

; 16. Function average calculates the mean of the numbers within a list
(define (average list) ; Define function
    (if (zero? (length list)) ; Evaluate if the list is empty
    0 ; if it's empty, assign 0
    (/ (add-list list) (length list)) ; use the previous add-list function to sum and calculate the average
    )
)
; Tests excercise 16
(average '())
(average '(4))
(average '(5 6 1 6 0 1 2))
(average '(1.7 4.5 0 2.0 3.4 5 2.5 2.2 1.2))

; 17. Recursive Function standard-deviation calculates the standard deviation of numbers within a list
(define (tail-standard-deviation list count endValue)
    (cond
    [(zero? (length list)) 0] ;if the list is of length 0 the return 0
    [(< count 0) (sqrt (/ endValue (length list)))] ;if the recursion has gone through every iteration then apply the sqrt and division to the stored sum (endValue)
    [else (tail-standard-deviation list (sub1 count) (+ (expt (- (list-ref list count) (average list)) 2) endValue))] ;Recursive Step, count decreases by one, recursive part ->endvalue+=(xi-average)
    )
    
)

;Wrapper Function standard-deviation
(define (standard-deviation list)
    (tail-standard-deviation list (sub1 (length list)) 0)
)
; Tests excercise 17
(standard-deviation '())
(standard-deviation '(4 8 15 16 23 42))
(standard-deviation '(110 105 90 100 95))
(standard-deviation '(9 2 5 4 12 7 8 11 9 3 7 4 12 5 4 10 9 6 9 4))

; 18. Function replic that returns a list of n copies for each element within a list
(define (replic num list)
    (if (zero? (length list)) ; Evaluate if the list is empty
        null ; if it's empty, assign 0
        ; Create a list with the first number on list repeated n times
        ; Append result to previous result (using recursion)
        (append (for/list ([i num])(first list)) (replic num (list-tail list 1))) 
    )
)
; Test excercise 18
(replic 5 '(1 2))
(replic 7 '())
(replic 0 '(a b c))
(replic 3 '(a))
(replic 4 '(1 2 3 4))

; 20. Function that converts a given number into binary. 
(define (tail-binary num accList)
    "Tail recursive function that converts from decimal to binary in the form of a list"
    (if(zero? num) ;when num==0 the accumulator list has saved all the remainders
        (reverse accList) ;reverse the list's elements, because remainders are appended backwards
        (tail-binary (quotient num 2) (append accList (list (remainder num 2)))) ; recursive step; binary(num is the quotient of the last iteration, append to the list the remainder of the current num)
    )
)

;Wrapper for the tail recursive binary function
(define (binary num)
    "Recursive functions that converts from decimal to binary in the form of a list"
    (tail-binary num '())
)

; Test excercise 20
(binary 0)
(binary 30)
(binary 45123)


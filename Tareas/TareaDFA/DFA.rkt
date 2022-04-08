#|
Implementation of a Deterministic Finite Automaton which
Identifies all the token types found in the input string 
according to the given language.

Return a list of tokens found
Used to validate input strings

Andreina Sananez | A01024927
Ana Paula Katsuda | A01025303
2022-04-08
|#

#lang racket

(provide arithmetic-lexer)

; Structure that describes a Deterministic Finite Automaton
(struct dfa-str (initial-state accept-states transitions))


;Wrapper for the automaton function
(define (arithmetic-lexer input-string)
  " Entry point for the lexer "
  (automaton-2 (dfa-str 'start '(int float var float_exp int_exp c_par) delta-arithmetic) input-string))

;Function that evaluates the string and validates it according to the language
(define (automaton-2 dfa input-string)
  " Evaluate a string to validate or not according to a DFA.
  Return a list of the tokens found"
  
  (let loop

    ;Define Variables -> state, chars, result
    ([state (dfa-str-initial-state dfa)]    ; Current state
     [chars (string->list input-string)]    ; List of characters
     [result null]                          ; List of tokens found
     [element null])                        ; List that stores an element/the entire token value 

     
    ;Check if char list is empty -> has reached the end
    (if (empty? chars)
      ; Check that the final state is in the accept states list -> (member state (dfa-str-accept-states dfa))
      (if (member state (dfa-str-accept-states dfa)) ; (dfa-str-accept-states dfa) extracting the accept-states from struct dfa
        (append result (list (list state (list->string element)))) #f) ;if true -> appends the list-pair to the result list
        
      ; Recursive loop with the new state and the rest of the list
      ; if the list is not empty
      (let-values
        ; Get the new token found and state by applying the transition function
        ([(token state) ((dfa-str-transitions dfa) state (car chars))]) ; token, state = transitionFunction(state, first element of char list)
        

        ;Recursive call
        (loop
          state ; state is the new value obtained by the transition function
          (cdr chars) ; the new char list is the last one minus the first element
          
          ; Update the list of tokens found -> if token is not false then store the pair in the result list
          (if token (append result (list (list token (list->string element)))) result)

          ; If token is true -> evuluate if there is a space to ignore (null) -> else function argument "element" is the first element of chars because its needed for the state change
          ; If token is false -> append the first element in chars in the argument list "element"
          (if token (if (eq? (car chars) #\space) null (list (car chars))) (append element (list (car chars)))))))))
          


;Define necessary functions for the transition function
(define (operator? char)
  (member char '(#\+ #\- #\* #\/ #\^ #\=)))

(define (sign? char)
  (member char '(#\+ #\-)))

(define (exponent? char)
  (member char '(#\E #\e)))


;Implementation of the transition function
(define (delta-arithmetic state character)
  " Transition to identify basic arithmetic operations "
  (case state
    ['start (cond
              [(char-numeric? character) (values #f 'int)]
              [(sign? character) (values #f 'n_sign)]
              [(char-alphabetic? character) (values #f 'var)]
              [(eq? character #\() (values #f 'o_par)]
              [else (values #f 'fail)])]

    ['n_sign (cond
               [(char-numeric? character) (values #f 'int)]
               [else (values #f 'fail)])]

    ['int (cond
            [(char-numeric? character) (values #f 'int)]
            [(exponent? character) (values #f 'i_exp)]
            [(operator? character) (values 'int 'op)]
            [(eq? character #\.) (values #f 'float)]
            [(eq? character #\space) (values 'int 'sp)]
            [(eq? character #\)) (values 'int 'c_par)]
            [else (values #f 'fail)])]

    ['float (cond
            [(char-numeric? character) (values #f 'float)]
            [(exponent? character) (values #f 'f_exp)]
            [(operator? character) (values 'float 'op)]
            [(eq? character #\space) (values 'float 'sp)]
            [(eq? character #\)) (values 'float 'c_par)]
            [else (values #f 'fail)])]
    
    ['i_exp (cond
            [(char-numeric? character) (values #f 'int_exp)]
            [(sign? character) (values #f 'i_exp_sign)]
            [else (values #f 'fail)])]

    ['f_exp (cond
            [(char-numeric? character) (values #f 'float_exp)]
            [(sign? character) (values #f 'f_exp_sign)]
            [else (values #f 'fail)])]

    ['int_exp (cond
            [(char-numeric? character) (values #f 'int_exp)]
            [(operator? character) (values 'int_exp 'op)]
            [(eq? character #\space) (values 'int_exp 'sp)]
            [(eq? character #\)) (values 'int_exp 'c_par)]
            [else (values #f 'fail)])]

    ['float_exp (cond
            [(char-numeric? character) (values #f 'float_exp)]
            [(operator? character) (values 'float_exp 'op)]           
            [(eq? character #\space) (values 'float_exp 'sp)]
            [(eq? character #\)) (values 'float_exp 'c_par)]
            [else (values #f 'fail)])]

    ['var (cond
            [(or (char-alphabetic? character) (eq? character #\_)) (values #f 'var)]
            [(char-numeric? character) (values #f 'var)]
            [(operator? character) (values 'var 'op)]
            [(eq? character #\space) (values 'var 'sp)]
            [(eq? character #\)) (values 'var 'c_par)]
            [else (values #f 'fail)])]
    
    ['op (cond
           [(char-numeric? character) (values 'op 'int)]
           [(char-alphabetic? character) (values 'op 'var)]
           [(sign? character) (values 'op 'n_sign)]
           [(eq? character #\space) (values 'op 'sp)]
           [(eq? character #\() (values 'op 'o_par)]
           [else (values #f 'fail)])]

    ['sp (cond
           [(char-numeric? character) (values #f 'int)]
           [(char-alphabetic? character) (values #f 'var)]
           [(operator? character) (values #f 'op)]
           [(sign? character) (values #f 'n_sign)]
           [(eq? character #\space) (values #f 'sp)]
           [(eq? character #\() (values #f 'o_par)]
           [(eq? character #\)) (values #f 'c_par)]
           [else (values #f 'fail)])]

    ['o_par (cond
           [(char-numeric? character) (values 'o_par 'int)]
           [(char-alphabetic? character) (values 'o_par 'var)]
           [(sign? character) (values 'o_par 'n_sign)]
           [(eq? character #\space) (values 'o_par 'sp)]
           [(eq? character #\() (values 'o_par 'o_par)]
           [(eq? character #\)) (values 'o_par 'c_par)]
           [else (values #f 'fail)])]

    ['c_par (cond
           [(eq? character #\space) (values 'c_par 'sp)]
           [(operator? character) (values 'c_par 'op)]
           [(eq? character #\() (values 'c_par 'o_par)]
           [(eq? character #\)) (values 'c_par 'c_par)]
           [else (values #f 'fail)])]


    ['fail (values #f 'fail)]))


;Run the code below for testing
(arithmetic-lexer "2")
(arithmetic-lexer "261")
(arithmetic-lexer "-63")
(arithmetic-lexer "5.23")
(arithmetic-lexer "-5.23")
(arithmetic-lexer ".23")
(arithmetic-lexer "2.2.3")
(arithmetic-lexer "4e8")
(arithmetic-lexer "4.51e8")
(arithmetic-lexer "-4.51e8")
(display "\n")
(arithmetic-lexer "data")
(arithmetic-lexer "data34")
(arithmetic-lexer "34data")
(arithmetic-lexer "2+1")
(arithmetic-lexer "/1")
(arithmetic-lexer "6 + 4 *+ 1")
(arithmetic-lexer "5.2+3")
(arithmetic-lexer "5.2+3.7")
(display "\n")
(arithmetic-lexer "one+two")
(arithmetic-lexer "one+two/45.2")
(display "\n")
(arithmetic-lexer "2 + 1")
(arithmetic-lexer "6 = 2 + 1")
(arithmetic-lexer "one + two / 45.2")
(arithmetic-lexer "97 /6 = 2 + 1")
(arithmetic-lexer "7.4 ^3 = 2.0 * 1")
(display "\n")
(arithmetic-lexer "(45)")
(arithmetic-lexer "( 45 )")
(arithmetic-lexer "(4 + 5)")
(arithmetic-lexer "(4 + 5) * (6 - 3)")





#|
- revisar espacios en start
- hacer condicion para espacios al final
- que identifique que es un operador y no un signo signo -> start_+3 (_+3) 

|#
;;; Global function with two args
(def sum
  (func [x y]
    (+ x y)))

;;; Global function with one arg
(def inc
  (func
    [value]
      (+ value 1)))

;;; Global function calling another functions
(def add100
  (func [x]
    (+ x 100)))

(def add200
  (func [x]
    (+ x 200)))

(def add300
  (func [x]
    (add200 (add100 x))))

;;; Positional destructuring
(def sum_of_list_of_two
  (func
    [[a b]]
      (+ a b)))

;;; Map with a regular function
(def inc_list
  (func
    [list]
      (map inc list) ))

;;; Map with a lambda function
(def double_list
  (func
    [list]
      (map (func [x](* x 2)))))

;;; Simple lambda function
(def lambda2
  (func
    []
      (func [] (+ 1 1))))

;;; Nested 3x lambda function returning a constant
(def lambda3
  (func
    []
      (func
        []
          ; returning a constant doesn't work :(
          ;(func [](3)))))
          (func [](+ 1 2)))))

;;; "using" and "namespace" tests
(def my_namespace
  (namespace {
    myFunc
      (func [x y](+ x y))
  }))

(def using_test1
  (func [x y]((using my_namespace myFunc) x y)))

;;; Fully qualified name to call a function
(def struct_handler
  (namespace {
    add100
      (func [x]
        (+ x 100))
    add200
      (func [x]
        (+ x 200))
    }))

(def add300b
  (func [x]
    (struct_handler.add200 (struct_handler.add100 x))))

;;; External files test
(require requiretest "./requiretest.zs");

(def testsum
  (func [x y]
    (+ 1 (+ x y))))

(def subfunc
  (func [x y]
    (+ 100 (testsum x y))))

(def tests (pairs [
    ; Simple call to global function
    (sum 1 2) 3

    ; Call to global function that calls another function
    (add300 2) 302

    ; Call to a positional destructuring function
    (sum_of_list_of_two [1 2]) 3

    ; Simple map to a function
    (inc_list [1 7]) [2 8]

    ; Simple lambda function within another function
    (lambda2) 2

    ; Multiple nested lambda functions returning constant
    (lambda3) 3

    ; This lambda doesn't work yet
    ;(func [](+ 1 1)) 2

    ; Maps with a lambda function doesn't work yet
    ;(double_list [1 2]) [2 4]

    ; Simple using test, using a namespace defined with a map
    (using_test1 1 2) 3

    ; Fully qualified names
    (struct_handler.add100 1) 101

    ; Nested function calls using fqn's
    (struct_handler.add100 (struct_handler.add200 1)) 301

    ; Global function that calls two fqn functions
    (add300b 2) 302

    ; Imported from external file
    (requiretest.testsum 7 13) 20

    ; Make sure the externally imported func didn't
    ; overwrite the one in this file.
    (testsum 7 13) 21

    ; Make sure imported funcs use the symbols defined in
    ; the external file.
    (requiretest.subfunc 7 13) 20

    ; Make sure global funcs don't use the imported symbols
    (subfunc 7 13) 121

    ]))

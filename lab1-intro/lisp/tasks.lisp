;; code for Task 1.2(a):
(print (1 + 2))
;; the above expression throws an error

;; code for Task 1.2(b):
(format t "type something: ")
(setf input (read-line))
(format t "you typed: ~a" input)

;; code for Task 1.2(c):
(setf prg '(+ 1 n)) ; define a very simple program
(print prg) ; print the program
; TODO: execute the program with n = 1 and print its result

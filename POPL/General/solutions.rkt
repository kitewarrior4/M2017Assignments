#lang racket
(require eopl)
(provide (all-defined-out))

(define wrap (lambda(x)
              (map
               (lambda(x)
                 (cons x '()))
               x
               )))

(define count-occurrences (lambda(x ls)
               (cond
                 [(null? ls) 0]
                 [(list? (car ls)) (+ (count-occurrences x (car ls)) (count-occurrences x (cdr ls)))]
                 [(equal? x (car ls)) (+ 1 (count-occurrences x (cdr ls)))]
                 (else (count-occurrences x (cdr ls))))))

(define merge (lambda(ls1 ls2)
                (cond
                  [(null? ls1) ls2]
                  [(null? ls2) ls1]
                  [(<= (car ls1) (car ls2)) (cons (car ls1) (merge (cdr ls1) ls2))]
                  (else (cons (car ls2) (merge (cdr ls2) ls1))))))

(define product (lambda(ls1 ls2)
                  (cond
                    [(null? ls1) '()]
                    [(null? ls2) '()]
                    [(list? ls1) (append
                                  (product (car ls1) ls2)
                                  (product (cdr ls1) ls2))]
                    [(list? ls2) (append
                                  (product ls1 (car ls2))
                                  (product ls1 (cdr ls2)))]
                    (else (list (list ls1 ls2))))))

(define traverse (lambda(v)
                   (cond
                     [(null? v) '()]
                     (else  (append (append (traverse (cadr v)) (list (car v))) (traverse (caddr v))))
                     )))

(define-datatype tree tree?
  [null]		;;; Null
  [node (val number?)	;;; Value of the node
        (left tree?)	;;; Left subtree
        (right tree?)])	;;; Right subtree

(define findpath
  (lambda (x t)
    (cases tree t
      [null () '()]
      [node (val left right)
            (cond
              [(equal? x val) '()]
              [(< x val) (cons 'left (findpath x left) )]
              [(> x val) (cons 'right (findpath x right) )])]
      )))

(define (curry f n)
  (let fi ((i n) (params '()))
    (cond
      [(equal? 0 i)
       (apply f params)]
      (else (lambda (x)
              (fi (- i 1) (append params (list x))))))))

(define is-subseq
  (lambda (ls1 ls2)
    (cond
      [(null? ls1) #t]
      [(null? ls2) #f]
      [(= (car ls1) (car ls2)) (is-subseq (cdr ls1) (cdr ls2))]
      (else (is-subseq ls1 (cdr ls2)))
      )))

(define tree-reduce
  (lambda (x f Tree)
    (cases tree Tree
      [null () x]
      [node (val left right) (f val (tree-reduce x f left) (tree-reduce x f right))]
      (else '()))))

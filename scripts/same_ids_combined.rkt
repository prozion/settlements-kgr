#!/usr/bin/env racket

#lang racket

(require odysseus)
(require odysseus/math)
(require tabtree)
(require tabtree/utils)

(define all_tabtrees
  (list
    (parse-tabtree "../source/russia_over_100K.tree")
    (parse-tabtree "../source/russia_100K_10K.tree")
    (parse-tabtree "../source/russia_10K_1K.tree")
    ; (parse-tabtree "../source/russia_5K_3K.tree")
    ; (parse-tabtree "../source/russia_3K_1K.tree")
    ))

(---
  (->>
    all_tabtrees
    (map hash-keys)
    flatten
    make-frequency-hash
    (hash-filter (λ (k v) (> v 1)))
    hash-keys
    list->pretty-string))

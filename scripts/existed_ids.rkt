#!/usr/bin/env racket

#lang racket

(require odysseus)
(require tabtree)
(require tabtree/utils)

(define all_tabtrees
  (t+
    (parse-tabtree "../source/russia_over_100K.tree")
    (parse-tabtree "../source/russia_100K_10K.tree")
    (parse-tabtree "../source/russia_10K_1K.tree")
    ))

(write-file
  "/home/denis/temp/settlements_kgr/existed_ids.txt"
  (->
    all_tabtrees
    hash-keys
    (list->pretty-string "\n")))

#!/usr/bin/env scheme-script
;; -*- mode: scheme; coding: utf-8 -*- !#
;; Copyright (c) 2022-2023 WANG Zheng
;; SPDX-License-Identifier: MIT
#!r6rs
;;to read log and reproduce similar action for debug
(import 
    (chezscheme) 
    (srfi :64 testing) 
    (scheme-langserver) 
    (scheme-langserver virtual-file-system file-node)
    (scheme-langserver virtual-file-system document)
    (scheme-langserver virtual-file-system index-node)

    (scheme-langserver util dedupe)

    (scheme-langserver analysis type substitutions rules trivial)
    (scheme-langserver analysis type domain-specific-language interpreter)
    (scheme-langserver analysis type domain-specific-language inner-type-checker)
    (scheme-langserver analysis workspace)
    (scheme-langserver analysis identifier reference)
    (scheme-langserver analysis identifier rules library-import))

; (test-begin "output-identifier-types")
;     (let* ([target-path (current-directory)] 
;             [workspace (init-workspace target-path #f #t #t)]
;             [root-library-node (workspace-library-node workspace)]
;             [target-library-identifier '(scheme-langserver analysis type domain-specific-language interpreter)]
;             ; [target-library-identifier '(industria crypto math)]
;             ; [target-library-identifier '(scheme-langserver util contain)]
;             ; [target-library-identifier '(hashing private compat)]
;             [identifier-references (import-references root-library-node target-library-identifier)])
;         (print-graph #t)
;         (pretty-print 'output-identifier-types)
;         (map 
;             (lambda (identifier-reference)
;                 (pretty-print (identifier-reference-identifier identifier-reference))
;                 (cond 
;                     [(not (null? (identifier-reference-type-expressions identifier-reference))) '()]
;                     ;because the identifier-reference-type-expressions may be the result of type:interpret-result-list
;                     [(null? (identifier-reference-document identifier-reference)) '()]
;                     [else
;                         (let* ([target-document (identifier-reference-document identifier-reference)]
;                             [env (make-type:environment (document-substitution-list target-document))]
;                             [result 
;                                 (
;                                     ; type:interpret-result-list
;                                     type:recursive-interpret-result-list 
;                                     (index-node-variable (identifier-reference-index-node identifier-reference)) env)])
;                             (identifier-reference-type-expressions-set! identifier-reference result))])
;                 (pretty-print 
;                     (filter 
;                         (lambda (i) (not (equal? i "something? ")))
;                         (dedupe (apply append (map type:interpret->strings (identifier-reference-type-expressions identifier-reference)))))))
;             identifier-references))
; (test-end)

(test-begin "output-identifier-types for index-node")
    (let* ([target-path (current-directory)] 
            [workspace (init-workspace target-path #f #t)]
            [root-library-node (workspace-library-node workspace)]
            ; [target-library-identifier '(scheme-langserver analysis workspace)]
            [target-library-identifier '(scheme-langserver analysis type domain-specific-language interpreter)]
            [identifier-references (import-references root-library-node target-library-identifier)])
        (print-graph #t)
        ((lambda (identifier-reference)
                (cond 
                    [(not (null? (identifier-reference-type-expressions identifier-reference))) '()]
                    ;because the identifier-reference-type-expressions may be the result of type:interpret-result-list
                    [(null? (identifier-reference-document identifier-reference)) '()]
                    [else
                        (let* ([target-document (identifier-reference-document identifier-reference)]
                            [env (make-type:environment (document-substitution-list target-document))]
                            [result 
                                (
                                    ; type:interpret-result-list
                                    type:recursive-interpret-result-list 
                                    (index-node-variable (identifier-reference-index-node identifier-reference)) env)])
                            (identifier-reference-type-expressions-set! identifier-reference result))])
                (pretty-print 
                    (filter 
                        (lambda (i) (not (equal? i "something? ")))
                        (dedupe (apply append (map type:interpret->strings (identifier-reference-type-expressions identifier-reference)))))))
            (find (lambda (i) (equal? 'type:depature&interpret->result-list (identifier-reference-identifier i))) identifier-references)))
(test-end)

(exit (if (zero? (test-runner-fail-count (test-runner-get))) 0 1))

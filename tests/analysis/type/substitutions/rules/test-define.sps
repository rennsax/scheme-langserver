#!/usr/bin/env scheme-script
;; -*- mode: scheme; coding: utf-8 -*- !#
;; Copyright (c) 2022 WANG Zheng
;; SPDX-License-Identifier: MIT
#!r6rs

(import 
    ; (rnrs (6)) 
    (chezscheme) 
    (srfi :64 testing) 
    (scheme-langserver virtual-file-system file-node)
    (scheme-langserver virtual-file-system index-node)
    (scheme-langserver virtual-file-system document)
    (scheme-langserver virtual-file-system library-node)

    (scheme-langserver util contain)

    (scheme-langserver analysis package-manager akku)
    (scheme-langserver analysis workspace)
    (scheme-langserver analysis tokenizer)
    (scheme-langserver analysis identifier reference)
    (scheme-langserver analysis identifier meta)
    (scheme-langserver analysis type domain-specific-language interpreter)
    (scheme-langserver analysis type domain-specific-language inner-type-checker)
    (scheme-langserver analysis type domain-specific-language variable)

    (scheme-langserver analysis type substitutions util)
    (scheme-langserver analysis type substitutions generator)

    (scheme-langserver protocol alist-access-object))

(test-begin "define for type inference")
    (let* ([workspace (init-workspace (string-append (current-directory) "/util/") '() #f #f)]
            [root-file-node (workspace-file-node workspace)]
            [root-library-node (workspace-library-node workspace)]
            [target-file-node (walk-file root-file-node (string-append (current-directory) "/util/matrix.sls"))]
            [target-document (file-node-document target-file-node)]
            [target-text (document-text target-document)]
            [target-index-node (pick-index-node-from (document-index-node-list target-document) (text+position->int target-text (make-position 49 10)))]
            [variable (index-node-variable target-index-node)]
            [check-base (construct-type-expression-with-meta 'number?)])
        (construct-substitution-list-for target-document)
        (test-equal #t 
            (contain? 
                (map car (filter list? (type:interpret-result-list variable (make-type:environment (document-substitution-list target-document))))) check-base)))
    (let* ([workspace (init-workspace (string-append (current-directory) "/util/") '() #f #f)]
            [root-file-node (workspace-file-node workspace)]
            [root-library-node (workspace-library-node workspace)]
            [target-file-node (walk-file root-file-node (string-append (current-directory) "/util/contain.sls"))]
            [target-document (file-node-document target-file-node)]
            [target-text (document-text target-document)]
            [target-index-node (pick-index-node-from (document-index-node-list target-document) (text+position->int target-text (make-position 6 12)))]
            [variable (index-node-variable target-index-node)]
            [check-base (construct-type-expression-with-meta 'boolean?)])
        (construct-substitution-list-for target-document)
        ; (debug:recursive-print-expression&variable (car (document-index-node-list target-document)))
        ; (debug:pretty-print-substitution (document-substitution-list target-document))
        ; (pretty-print (map inner:type->string (type:recursive-interpret-result-list variable (make-type:environment (document-substitution-list target-document)))))
        (test-equal #t 
            (contain? 
                (map car (filter list? (type:interpret-result-list variable (make-type:environment (document-substitution-list target-document))))) check-base)))
(test-end)

(test-begin "debug for index-node.sls:debug:print-expressions")
    (let* ([workspace (init-workspace (string-append (current-directory) "/virtual-file-system/") '() #f #t)]
            [root-file-node (workspace-file-node workspace)]
            [root-library-node (workspace-library-node workspace)]
            [target-file-node (walk-file root-file-node (string-append (current-directory) "/virtual-file-system/index-node.sls"))]
            [target-document (file-node-document target-file-node)]
            [target-text (document-text target-document)]
            [target-index-node (pick-index-node-from (document-index-node-list target-document) (text+position->int target-text (make-position 102 10)))]
            [variable (index-node-variable target-index-node)]
            [check-base 'void?])
        (test-equal #t 
            (contain? 
                (map car (filter list? (type:interpret-result-list variable (make-type:environment (document-substitution-list target-document))))) check-base)))
(test-end)

; a better cutting is needed
; (test-begin "cartesian-products may slow down the inference because combination blows up")
;     (let* ([workspace (init-workspace (string-append (current-directory) "/util/") '() #f #f)]
;             [root-file-node (workspace-file-node workspace)]
;             [root-library-node (workspace-library-node workspace)]
;             [target-file-node (walk-file root-file-node (string-append (current-directory) "/util/binary-search.sls"))]
;             [target-document (file-node-document target-file-node)]
;             [target-text (document-text target-document)]
;             [target-index-node (pick-index-node-from (document-index-node-list target-document) (text+position->int target-text (make-position 4 12)))]
;             [variable (index-node-variable target-index-node)]
;             [check-base (construct-type-expression-with-meta 'boolean?)])
;         (construct-substitution-list-for target-document)
;         ; (debug:recursive-print-expression&variable (car (document-index-node-list target-document)))
;         (test-equal #t 
;             (contain? 
;                 (map car (filter list? (type:interpret-result-list variable (make-type:environment (document-substitution-list target-document))))) check-base)))
; (test-end)

(exit (if (zero? (test-runner-fail-count (test-runner-get))) 0 1))
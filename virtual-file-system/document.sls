(library (scheme-langserver virtual-file-system document)
  (export 
    make-document
    document?
    document-uri
    document-text
    document-text-set!
    document-index-node-list
    document-index-node-list-set!
    document-ordered-reference-list
    document-ordered-reference-list-set!
    document-substitution-list
    document-substitution-list-set!
    document-refreshable?
    document-refreshable?-set!)
  (import (rnrs)
    (only (srfi :13 strings) string-prefix? string-suffix?))

(define-record-type document 
  (fields 
    (immutable uri)
    ;now it is only used for type-inference in analysis/type/substitutions/trivial.sls
    (mutable text)
    (mutable index-node-list)
    (mutable ordered-reference-list)
    (mutable substitution-list)
    (mutable refreshable?))
  (protocol
    (lambda (new)
      (lambda (uri text index-node-list reference-list)
        (new uri text index-node-list reference-list '() #t)))))
)

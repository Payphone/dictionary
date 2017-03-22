;;;; dictionary.asd

(asdf:defsystem #:dictionary
  :description "A StumpWM module for dictionary lookups."
  :author "Peyton Farrar <peyton@peytonfarrar.com>"
  :license "MIT"
  :depends-on (#:plump
               #:plump-sexp
               #:trivial-http
               #:stumpwm)
  :serial t
  :components ((:file "package")
               (:file "dictionary")))

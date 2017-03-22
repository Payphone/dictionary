;;;; dictionary.asd

(asdf:defsystem #:dictionary
  :description "A StumpWM module for looking up definitions in the
               Merriam-Webster dictionary."
  :author "Peyton Farrar <peyton@peytonfarrar.com>"
  :license "MIT"
  :depends-on (#:plump
               #:trivial-http
               #:stumpwm)
  :serial t
  :components ((:file "package")
               (:file "dictionary")))

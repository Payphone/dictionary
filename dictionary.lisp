;;;; dictionary.lisp

(in-package #:dictionary)

(defvar *api-key* nil
  "Merriam-Webster API key, you must register for this at
  http://dictionaryapi.com/")

(define-condition no-definitions-found (error) ())
(define-condition no-api-key (error) ())

(defstruct word
  (name)
  (definitions))

(defun lastcar (list)
  "Returns the last element in a list."
  (car (last list)))

(defun breakup-long-string (string &optional (max-length 80))
  "Inserts a newline after the max length is reached."
  (labels ((rec (list count acc)
             (let ((char (car list)))
               (if list
                   (if (= count max-length)
                       (rec (cdr list) 0 (cons #\Newline (cons char acc)))
                       (rec (cdr list) (1+ count) (cons char acc)))
                   (coerce (reverse acc) 'string)))))
    (rec (coerce string 'list) 1 nil)))

(defun get-definitions (node)
  "Returns all definition entries found."
  (or (plump:get-elements-by-tag-name node :dt)
      (error 'no-definitions-found)))

(defun serialize-word (stream)
  "Serializes the stream returned by the dictionary API."
  (let ((plump:*tag-dispatchers* plump:*xml-tags*))
    (mapcar #'(lambda (def) (breakup-long-string (plump:text def)))
            (get-definitions (plump:parse (plump:slurp-stream stream))))))

(defun word-lookup (word key)
  "Searches for a word in the Merriam-Webster dictionary."
  (if key
      (make-word :name word
                 :definitions
                 (serialize-word
                  (lastcar (trivial-http:http-get
                            (concatenate 'string "http://www.dictionaryapi.com/"
                                         "api/v1/references/collegiate/xml/" word
                                         "?key=" key)) :timeout 5)))
      (error 'no-api-key)))

(defcommand get-definition (word) ((:string "Look up what word? "))
  "Find the definition of a word."
  (handler-case
      (let ((*suppress-echo-timeout* t))
        (message "~A: ~%~{~A~%~}" word
                 (word-definitions (word-lookup word *api-key*))))
    (no-definitions-found ()
      (message (format nil "No known definitions for ~A." word)))
    (no-api-key ()
      (message "You have not added an API key. You won't be able to look up
               definitions without this!"))
    (t ()
      (message "Can't connect to http://dictionaryapi.com"))))

(require 'eproject)

(define-project-type xplan (generic)
  (look-for ".project")
   :relevant-files ("\\.py$" "\\.js$"))

(define-project-type python (generic)
  (look-for ".project")
  :relevant-files ("\\.py$" "\\.js$"))

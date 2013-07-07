(require 'eproject)
(define-project-type python (generic)
  (look-for ".eproject")
  :relevant-files ("\\.py$" "\\.js$"))

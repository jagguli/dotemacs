(require 'eproject)

(define-project-type xplan (generic)
  (look-for ".xplanproj")
   :relevant-files ("\\.py$" "\\.js$"))

(define-project-type python (generic)
  (look-for ".eproject")
  :relevant-files ("\\.py$" "\\.js$"))

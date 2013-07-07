(require 'eproject)

(define-project-type xplan (generic)
  (look-for ".xplanproj")
   :relevant-files ("\\.py$" "\\.js$"))

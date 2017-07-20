(req-package web-mode
  :require
  (
   haml-mode
   )
  :config
  (setq
   mweb-default-major-mode 'html-mode
   mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
               (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
               (css-mode "<style +type=\"text/css\"[^>]*>" "</style>"))
   mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5")
   sgml-indent-line 4
   sgml-basic-offset 4
   )
  :init
  (progn
    (multi-web-global-mode 1)
    )
  )

(req-package web-mode
  :config
  (setq
   mweb-default-major-mode 'html-mode
   mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
               (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
               (css-mode "<style +type=\"text/css\"[^>]*>" "</style>"))
   mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5")
   )
  :init
  (progn
    (multi-web-global-mode 1)
    )
  )

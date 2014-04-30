;;(setq speedbar-fetch-etags-command "/home/steven/bin/tagquery.py")
;;            speedbar-fetch-etags-arguments '(""))
(load "speedbar")
(setq speedbar-fetch-etags-parse-list
      (cons '("\\.py\\'" . speedbar-parse-c-or-c++tag)
                        speedbar-fetch-etags-parse-list))
(setq speedbar-fetch-etags-arguments nil)
(setq speedbar-fetch-etags-command "tagquery.py")
(setq speedbar-supported-extension-expressions (quote (".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?" ".tex\\(i\\(nfo\\)?\\)?" ".el" ".emacs" ".l" ".lsp" ".p" ".java" ".js" ".f\\(90\\|77\\|or\\)?" ".py")))
(setq speedbar-use-imenu-flag nil)
(setq speedbar-verbosity-level 2)
(setq speedbar-dynamic-tags-function-list
      (delete (first speedbar-dynamic-tags-function-list)
              speedbar-dynamic-tags-function-list))

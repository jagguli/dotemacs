(req-package buffer-timer
  :config
                                        ; Example list of titles and regexps to group by.  This
  (setq buffer-timer-regexp-master-list
        '(
          ("idle" . 
           (("generic" .			  "^\\*idle\\*")
            ("generic2" .			  "^\\*idle-2\\*")
            ("minibuf" .                        "^ \\*Minibuf-.*")))
          ("personal" .
           (("emacs" .                        "~/.emacs.d/")
            ("photography" .                    "images/capturedonearth")))
          ("work" .
           (("rocket engine project" .
             (("docs" .                        "src/rocket.*org")
              ("code" .                        "src/rocket.*\\(cpp\\|h\\)$")
              ("generic" .                     "src/rocket")))
            ("world peace" .
             (("project planning" .            "src/worldpeas/TODO")
              ("implementation" .              "src/worldpeas")))))
          )
        )
  )

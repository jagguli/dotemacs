(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(require 'jedi-direx)
(eval-after-load "python"
    '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
(setq jedi:server-args
      '("--sys-path" "/home/steven/iress/xplan99/src/py/"
        "--sys-path" "/home/steven/iress/xplan99/lib/py/"))


(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))


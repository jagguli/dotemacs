;;(add-to-list 'load-path "~/.emacs.d/jslint-v8")
;;(add-hook 'javascript-mode-hook
;;                    (lambda () (flymake-mode t)))
;;(setq jslint-v8-shell "/usr/bin/d8")

(defun my-js-mode-hooks ()
  (flycheck-mode t))
(add-hook 'js-mode-hook 'my-js-mode-hooks)

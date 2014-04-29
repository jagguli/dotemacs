;;(add-to-list 'load-path "~/.emacs.d/jslint-v8")
;;(add-hook 'javascript-mode-hook
;;                    (lambda () (flymake-mode t)))
;;(setq jslint-v8-shell "/usr/bin/d8")

(autoload 'tern-mode "tern.el" nil t)

(defun my-js-mode-hooks ()
  (flycheck-mode t))
(add-hook 'js-mode-hook 'my-js-mode-hooks)

(add-hook 'js-mode-hook (lambda () (tern-mode t)))


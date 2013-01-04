;; Enable flymake for all files
(add-hook 'find-file-hook 'flycheck-mode-on)
;; Enable flymake for Python only
(add-hook 'python-mode-hook 'flycheck-mode-on)

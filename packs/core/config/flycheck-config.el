;; Enable flymake for all files
(add-hook 'find-file-hook 'flycheck-mode-on)
;; Enable flymake for Python only
(add-hook 'python-mode-hook 'flycheck-mode-on)
;;(setq flymake-no-changes-timeout 5)
;;(add-hook 'evil-normal-state-entry-hook 'flymake-start-syntax-check)



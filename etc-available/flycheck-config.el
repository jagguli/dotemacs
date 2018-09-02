(use-package flycheck
  :ensure t
  :after pipenv
  :init (progn
          (global-flycheck-mode 1)
          (defun pipenv-activate-pycheckers ()
            "Activate integration of Pipenv with Flycheck."
            (interactive)
            (setq flycheck-pycheckers-venv-root  (pipenv-venv))
            )
          ;;(if (< (count-lines (point-min) (point-max)) 2000) 
          ;;    (flycheck-mode) 
          ;;  (flycheck-mode -1))
          ;;(add-hook 'pipenv-mode-hook 'pipenv-activate-pycheckers)
          ;;(add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup)
          ;;(add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))
          ;;(add-hook 'python-mode-hook 'flycheck-mode-on-safe)
          ;;(add-hook 'js2-mode-hook 'flycheck-mode-on-safe)
          ;;(add-hook 'javascript-mode-hook 'flycheck-mode-on-safe)
          ;;(add-hook 'evil-normal-state-entry-hook 'flymake-start-syntax-check)
          )
  )

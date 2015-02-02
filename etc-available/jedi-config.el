(req-package jedi
  :init
  (progn 
    (add-user-lib "emacs-jedi")
    (add-user-lib "emacs-jedi-direx")

    (setq jedi:setup-keys t)                      ; optional
    (setq jedi:complete-on-dot t)                 ; optional
    (require 'jedi-direx)

    (setq jedi:server-args
          '("--sys-path" "/home/steven/iress/xplan/src/py/"
            "--sys-path" "/home/steven/iress/xplan/lib/py/"
            "--sys-path" "/usr/lib/python2.7/site-packages/"
            "--sys-path" "/home/steven/.local/lib/python2.7/site-packages/"
            ))

    (defun my-jedi-python-mode-hook ()
      (define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer)
      (define-key evil-normal-state-map (kbd "C-]") 'jedi:goto-definition)
      (define-key evil-normal-state-map (kbd "C-t") 'jedi:goto-definition-pop-marker)
      (define-key evil-normal-state-map (kbd "C-M-]") 'helm-jedi-related-names)
      ) 

    (add-hook 'python-mode-hook 'jedi:setup)
    (add-hook 'python-mode-hook 'my-jedi-python-mode-hook)
    (add-hook 'jedi-mode-hook 'jedi-direx:setup)
    )
  )

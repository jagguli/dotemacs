(add-user-lib "emacs-jedi")
(add-user-lib "emacs-jedi-direx")
(req-package jedi
  :require (python-mode jedi-direx)
  :config
  (setq
   jedi:setup-keys t
   jedi:complete-on-dot t
   jedi:server-args
   '("--sys-path" "/home/steven/iress/xplan/src/py/"
     "--sys-path" "/home/steven/iress/xplan/lib/py/"
     "--sys-path" "/usr/lib/python2.7/site-packages/"
     "--sys-path" "/home/steven/.local/lib/python2.7/site-packages/"
     )
   )
  :init
  (progn 
    (defun my-jedi-python-mode-hook ()
      (interactive)
      (jedi:setup)
      (define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer)
      (define-key evil-normal-state-map (kbd "C-]") 'jedi:goto-definition)
      (define-key evil-normal-state-map (kbd "C-t") 'jedi:goto-definition-pop-marker)
      (define-key evil-normal-state-map (kbd "C-M-]") 'helm-jedi-related-names)
      (define-key evil-insert-state-map (kbd "C-c SPC") 'jedi:complete)
      ) 

    (add-hook 'python-mode-hook 'my-jedi-python-mode-hook)
    (add-hook 'jedi-mode-hook 'jedi-direx:setup)
    )
  )

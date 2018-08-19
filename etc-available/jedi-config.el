(req-package jedi
  :require (jedi-direx)
  :config
  (setq
   popup-use-optimized-column-computation nil
   jedi:setup-keys t
   jedi:complete-on-dot t
   jedi:install-server--command `("pip2" "install" "--upgrade" ,(convert-standard-filename jedi:source-dir))
   jedi:server-command (list "python" jedi:server-script)
   jedi:server-args
   '("--sys-path" "/home/steven/streethawk/slicecloud/"
     "--sys-path" "/home/steven/.local/lib/python2.7/site-packages/"
     "--sys-path" "/home/steven/.local/lib/python3.5/site-packages/"
     "--sys-path" "/usr/lib/python3.6/site-packages/"
     "--sys-path" "/usr/lib/python3.6/dist-packages/"
     "--sys-path" "/usr/lib/python2.7/site-packages/"
     "--sys-path" "/usr/lib/python2.7/dist-packages/"
     )
   )
  :init
  (progn 
    (defun my-jedi-python-mode-hook ()
      (interactive)
      (jedi:setup)
      (define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer)
      (define-key evil-normal-state-local-map (kbd "C-]") 'jedi:goto-definition)
      (define-key evil-normal-state-local-map (kbd "C-t") 'jedi:goto-definition-pop-marker)
      (define-key evil-normal-state-local-map (kbd "C-M-]") 'helm-jedi-related-names)
      (define-key evil-insert-state-local-map (kbd "C-c SPC") 'jedi:complete)
      ) 

    ;(add-hook 'python-mode-hook 'my-jedi-python-mode-hook)
    ;(add-hook 'jedi-mode-hook 'jedi-direx:setup)
    )
  )

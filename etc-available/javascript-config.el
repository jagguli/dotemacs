;;(autoload 'tern-mode "tern.el" nil t)
(req-package js2-mode
  :init
  (progn

    (defun my-js-mode-hooks ()
      (flycheck-mode t)
      (tern-mode t)
      (define-key evil-normal-state-map (kbd "C-]") 'tern-find-definition)
      (define-key evil-normal-state-map (kbd "C-t") 'tern-pop-find-definition)
      (define-key evil-normal-state-map (kbd "C-M-]") 'tern-find-definition-by-name)
      (if (not (or
                (string/starts-with (buffer-name) "*mo-git-blame")
                (string/starts-with (buffer-name) "*svn-status")
                ))
          (progn
            (define-key evil-normal-state-map "za" 'js3-mode-toggle-element)
            (define-key evil-normal-state-map "\t" 'js3-mode-toggle-element)
            (define-key evil-normal-state-map "zo" 'js3-mode-show-element)
            (define-key evil-normal-state-map "zO" 'hide-other)
            (define-key evil-normal-state-map "zc" 'hide-entry)
            (define-key evil-normal-state-map "zr" 'js3-mode-show-node)
            (define-key evil-normal-state-map "zR" 'js3-mode-show-all)
            (define-key evil-normal-state-map "zm" 'js3-mode-hide-functions)
            (define-key evil-normal-state-map "zM" 'hide-sublevels)
            (define-key evil-normal-state-map (kbd "C-i")  'evil-jump-forward)
            )
        )
      )

    (add-hook 'js3-mode-hook 'my-js-mode-hooks)
    )
  )


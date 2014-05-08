(autoload 'tern-mode "tern.el" nil t)

(defun my-js-mode-hooks ()
  (flycheck-mode t)
  (tern-mode t)
  (define-key evil-normal-state-map (kbd "C-]") 'tern-find-definition)
  (define-key evil-normal-state-map (kbd "C-t") 'tern-pop-find-definition)
  (define-key evil-normal-state-map (kbd "C-M-]") 'tern-find-definition-by-name)
)

(add-hook 'js-mode-hook 'my-js-mode-hooks)



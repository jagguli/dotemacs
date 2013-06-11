(add-hook 'ecb-history-buffer-after-create-hook 'evil-emacs-state)
(add-hook 'ecb-directories-buffer-after-create-hook 'evil-emacs-state)
(add-hook 'ecb-methods-buffer-after-create-hook 'evil-emacs-state)
(add-hook 'ecb-sources-buffer-after-create-hook 'evil-emacs-state)

(require 'ecb)

(define-key global-map (kbd "<f4>") '(lambda ()
                                       (interactive)
                                       (ecb-activate)
                                       (ecb-toggle-ecb-windows)))
(define-key global-map (kbd "<f5>") '(lambda ()
                                       (interactive)
                                       (ecb-activate)
                                       (ecb-toggle-layout)))

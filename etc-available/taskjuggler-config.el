(require 'taskjuggler-mode)
(require 'hideshow)

(add-hook 'taskjuggler-mode-hook 
          (lambda () 
            (hs-minor-mode)
            (hs-hide-all)
            (define-key evil-normal-state-map (kbd "za") 'evil-toggle-fold)
            )
)

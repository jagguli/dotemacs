(require 'taskjuggler-mode)

(add-hook 'taskjuggler-mode-hook 
          (lambda () 
            (hs-minor-mode)
            (hs-hide-all)
            (define-key evil-normal-state-map "za" 'hs-show-all)
            )
)

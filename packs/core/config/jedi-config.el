(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(require 'jedi-direx)
(eval-after-load "python"
    '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))

; http://stackoverflow.com/questions/4079648/combine-python-mode-with-org-mode-for-emacs/4093889#4093889
; require outline-magic.el by CarstenDominik found here: 
; http://www.astro.uva.nl/~dominik/Tools/outline-magic.el
; modified code here by Nikwin slightly found here: 
;  http://stackoverflow.com/questions/1085170/how-to-achieve-code-folding-effects-in-emacs/1085551#1085551

(add-hook 'outline-minor-mode-hook 
           (lambda () 
             (require 'outline-magic)
))
(add-hook 'python-mode-hook 'my-python-outline-hook)

(defun py-outline-level ()
  (let (buffer-invisibility-spec)
    (save-excursion
      (skip-chars-forward "    ")
      (current-column))))

(defun my-python-outline-hook ()
  (setq outline-regexp "[ \t]*# \\|[ \t]+\\(class\\|def\\|if\\|elif\\|else\\|while\\|for\\|try\\|except\\|with\\) ")
  (setq outline-level 'py-outline-level)

  (outline-minor-mode t)
  (hide-body)
  (show-paren-mode 1)
  (define-key python-mode-map [tab] 'outline-cycle)
  (define-key outline-minor-mode-map [S-tab] 'indent-for-tab-command)
  (define-key outline-minor-mode-map [M-down] 'outline-move-subtree-down)
  (define-key outline-minor-mode-map [M-up] 'outline-move-subtree-up)
)
(provide 'python-magic)

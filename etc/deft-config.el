(req-package deft
  :config
  (setq
   deft-extensions '("txt" "tex" "org")
   deft-directory "~/org/"
  )
  :init
  (progn
    (global-set-key (kbd "C-c d") 'deft)
    )
)

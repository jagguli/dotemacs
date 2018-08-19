(req-package buffer-move
  :init
  (progn
    (global-set-key (kbd "<C-S-up>")     'buf-move-up)
    (global-set-key (kbd "<C-S-down>")   'buf-move-down)
    (global-set-key (kbd "<C-S-left>")   'buf-move-left)
    (global-set-key (kbd "<S-C-right>")  'buf-move-right)
    )
  )

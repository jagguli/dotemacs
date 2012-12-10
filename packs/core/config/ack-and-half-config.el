(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;;grep window
(setq split-width-threshold nil)
(defun my-grep ()
  "Run grep and resize the grep window"
  (interactive)
  (progn
    (call-interactively 'grep)
    (setq cur (selected-window))
    (setq w (get-buffer-window "*grep*"))
    (select-window w)
    (setq h (window-height w))
    (shrink-window (- h 15))
    (select-window cur)
    )
  )
(defun my-grep-hook () 
  "Make sure that the compile window is splitting vertically"
  (progn
    (if (not (get-buffer-window "*grep*"))
       (progn
      (split-window-vertically)))))
(add-hook 'grep-mode-hook 'my-grep-hook)
(global-set-key [f6] 'my-grep)

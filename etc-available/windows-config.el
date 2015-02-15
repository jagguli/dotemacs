(req-package windmove
  :init
  (progn
    (windmove-default-keybindings 'control)
    (setq default-frame-alist
          '(
            (width . 100) ; character
            (height . 52) ; lines
            (foreground-color . blue)
                    ))
    ;; Reverse colors for the border to have nicer line
    (set-face-inverse-video-p 'vertical-border nil)
    (set-face-background 'vertical-border (face-background 'default))

    ;; Set symbol for the border
    ;; http://stackoverflow.com/questions/18210631/how-to-change-the-character-composing-the-emacs-vertical-border
    (set-display-table-slot standard-display-table
                            'vertical-border
                                                    (make-glyph-code ?│))


    ;;(global-set-key (kbd "C-<left>")  'windmove-left)
    ;;(global-set-key (kbd "C-<right>") 'windmove-right)
    ;;(global-set-key (kbd "C-<up>")    'windmove-up)
    ;;(global-set-key (kbd "C-<down>")  'windmove-down)
    ;;http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-5-5
    (defun sacha/vsplit-last-buffer (prefix)
      "Split the window vertically and display the previous buffer."
      (interactive "p")
      (split-window-vertically)
      (other-window 1 nil)
      (unless prefix
        (switch-to-next-buffer)))
    (defun sacha/hsplit-last-buffer (prefix)
      "Split the window horizontally and display the previous buffer."
      (interactive "p")
      (split-window-horizontally)
      (other-window 1 nil)
      (unless prefix (switch-to-next-buffer)))
    (bind-key "C-x 2" 'sacha/vsplit-last-buffer)
    (bind-key "C-x 3" 'sacha/hsplit-last-buffer)

    )
  )

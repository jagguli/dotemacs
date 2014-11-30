(windmove-default-keybindings 'control)


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

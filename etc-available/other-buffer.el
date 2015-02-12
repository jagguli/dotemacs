(defun buffer-mode (buffer-or-string)
  "Returns the major mode associated with a buffer."
  (with-current-buffer buffer-or-string
    (format "%s" major-mode)))

(defun other-buffer-ex ()
  (interactive)
  (switch-to-buffer (if (string-equal (buffer-mode (other-buffer)) "comint-mode")
         (next-buffer) (other-buffer))))  

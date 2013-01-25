(require 'grin)
(defun grin-xplan ()
  (interactive )
  (let* ((c (concat grin-cmd " \"\" ~/iress/xplan/src/py/xpt/"))
         (l (length c))
         (cmd (read-shell-command "Command: " (cons c l) 'grin-hist))
         (null-device nil))
    (grep cmd)))

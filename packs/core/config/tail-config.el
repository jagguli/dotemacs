(require 'itail)
(defun itail-xplan-server (branch)
  (interactive "nBranch: \n")
  (if (eq branch 0) (setq branch "") (setq branch (number-to-string branch)))
  (itail (format "~/iress/xplan%s/var/local/log/server.log" branch))
  )

(defun itail-xplan-stderr (branch)
  (interactive "nBranch: \n")
  (if (eq branch 0) (setq branch "") (setq branch (number-to-string branch)))
  (itail (format "~/iress/xplan%s/var/local/log/stderr.log" branch))
  )

(add-hook 'itail-mode-hook
      #'(lambda ()
          (compilation-minor-mode 1)))

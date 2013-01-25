;; PSVN ================================================================================
(require 'psvn)
(setq svn-status-hide-unknown t)
(setq svn-status-hide-unmodified t)
;;(add-hook 'svn-status-mode-hook 
;;          #'(lambda ()
;;              (evil-mode 0)
;;              )
;;          )
(defun svn-add nil
  (interactive)
  (insert (buffer-file-name (nth 1 (buffer-list)))))

(defalias 'svn-log 'svn-status-show-svn-log)
;;(defun 'svn-ediff)


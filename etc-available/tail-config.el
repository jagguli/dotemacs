(req-package itail
  :init
  (progn

    (defun itail (file)
      "Tail file FILE in itail mode.  Supports remote tailing through tramp "
      (interactive "ftail file: ")
      (let* ((buffer-name (concat "tail " file))
             (remote-match (string-match "\\(.*:\\)\\(.*\\)" file))
             (default-directory (if remote-match (match-string 1 file) default-directory))
             (file (if remote-match
                       (match-string 2 file)
                     (expand-file-name file))))
        (make-comint buffer-name "tail" nil "-F" file)
        (pop-to-buffer (concat "*" buffer-name "*")))
      (ansi-color-for-comint-mode-on)
      (add-hook 'comint-preoutput-filter-functions 'itail-output-filter)
      (setq itail-file file)
      (setq itail-filters ())
      (itail-mode-line)
      (itail-mode)
      )

    (defun itail-xplan-server (branch)
      (interactive "nBranch: \n")
      (if (eq branch 0) (setq branch "") (setq branch (number-to-string branch)))
      (itail (expand-file-name (format "~/iress/xplan%s/var/local/log/server.log" branch)))
      )

    (defun itail-xplan-stderr (branch)
      (interactive "nBranch: \n")
      (if (eq branch 0) (setq branch "") (setq branch (number-to-string branch)))
      (itail (expand-file-name (format "~/iress/xplan%s/var/local/log/stderr.log" branch)))
      )

    (add-hook 'itail-mode-hook
              #'(lambda ()
                  (define-key itail-keymap (kbd "C-g" ) 'goto-end)
                  (compilation-minor-mode 1)))

    (defun goto-end nil
      (interactive)
      (goto-line (point-max)))
    )
  )

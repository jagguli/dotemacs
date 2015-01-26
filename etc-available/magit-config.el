(req-package magit
  :require (git-commit-mode password-store)
  :init
  (progn
    (global-set-key "\C-xgg" 'magit-status)
    (global-set-key "\C-xgb" 'mo-git-blame-current)
    )
  )

(req-package magit-gerrit
  :require (magit)
  :init
  (progn
    (defun gerrit-check-if-repo-modified ()
      "Check if current repo has been modified."
      (null (mapcar (lambda (line)
                      (string-match "^[ \t]+M" line))
                    (magit-git-lines "status" "--porcelain -uno"))))

    ;; if necessary, use an alternative remote instead of 'origin'
    (setq-default magit-gerrit-remote "gerrit")  


    (defun gerrit ()
      (interactive)
      ;; if remote url is not using the default gerrit port and
      ;; ssh scheme, need to manually set this variable
      (setq-default magit-gerrit-ssh-creds (password-store-get "iress/user"))
      )


    (defun magit-add-current-file ()
      "Insert the full path file name into the current buffer."
      (interactive)
      (let ((file-path (buffer-file-name
                        (window-buffer))))
        (let ((default-directory (file-name-directory file-path)))
          (message file-path)
          (shell-command 
           (concat "git add " file-path)))))
    )
  )
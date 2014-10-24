(global-set-key "\C-xgg" 'magit-status)

(defun gerrit-check-if-repo-modified ()
  "Check if current repo has been modified."
  (null (mapcar (lambda (line)
                       (string-match "^[ \t]+M" line))
                     (magit-git-lines "status" "--porcelain -uno"))))


(require 'magit-gerrit)

;; if remote url is not using the default gerrit port and
;; ssh scheme, need to manually set this variable
(setq-default magit-gerrit-ssh-creds "steven.joseph@iress.com.au")

;; if necessary, use an alternative remote instead of 'origin'
(setq-default magit-gerrit-remote "gerrit")  

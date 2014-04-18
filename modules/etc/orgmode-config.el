(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(define-key global-map "c l" 'org-store-link)
;;(define-key global-map "c a" 'org-agenda)
(setq org-log-done t)
(setq org-directory "~/share/Dropbox/OrgMode/")
(setq org-from-is-user-regexp nil)
(setq org-log-done t)
(setq org-mobile-directory (concat org-directory "MobileOrg/"))
(setq org-mobile-inbox-for-pull (concat org-mobile-directory "mobileorg.org"))
(setq org-return-follows-link t)
(setq org-todo-keywords (quote ((sequence "TODO" "DONE" "CANCELED"))))

(defun add-agenda-file (p)
  (add-to-list 'org-agenda-files (concat org-directory p)))

(add-agenda-file "work.org")
(add-agenda-file "startup.org")
(add-agenda-file "zen.org")
(add-agenda-file "notes.org")

(defun note ()
  (interactive)
  (find-file (concat org-directory "notes.org"))
  (goto-char (point-min))
  (insert "------------------------------------------------------------\n")
  (esk-insert-date)
  (insert "\n\n")
 (previous-line) )
;;(add-hook 'after-init-hook 'org-agenda-list)


(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(define-key global-map "c l" 'org-store-link)
;;(define-key global-map "c a" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/Dropbox/OrgMode/work.org"
                             "~/Dropbox/OrgMode/todos.org" 
                             "~/Dropbox/OrgMode/startup.org" 
                             "~/Dropbox/OrgMode/zen.org" 
                             "~/Dropbox/OrgMode/home.org"))

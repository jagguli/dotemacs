(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(define-key global-map "c l" 'org-store-link)
;;(define-key global-map "c a" 'org-agenda)
(setq org-log-done t)
(setq org-directory (expand-file-name "~/share/Dropbox/OrgMode/"))
;;(setq org-directory (expand-file-name "~/share/orgmodegoogle/melit.stevenjoseph@gmail.com/OrgMode/"))
(setq org-from-is-user-regexp nil)
(setq org-log-done t)
(setq org-mobile-directory (concat org-directory "MobileOrg/"))
(setq org-mobile-inbox-for-pull (concat org-mobile-directory "mobileorg.org"))
(setq org-return-follows-link t)
(setq org-todo-keywords (quote ((sequence "TODO" "DONE" "CANCELED"))))
(setq org-catch-invisible-edits t)
(setq org-agenda-file-regexp "[^.].*\\.org$")

(defun add-agenda-file (p)
  (add-to-list 'org-agenda-files (concat org-directory p)))

(add-agenda-file "")
;;(add-agenda-file "work.org")
;;(add-agenda-file "startup.org")
;;(add-agenda-file "zen.org")
;;(add-agenda-file "notes.org")

(defun note ()
  (interactive)
  (find-file (concat org-directory "notes.org"))
  (goto-char (point-min))
  (insert "------------------------------------------------------------\n")
  (esk-insert-date)
  (insert "\n\n")
 (previous-line) )
;;(add-hook 'after-init-hook 'org-agenda-list)


(defun my-org-files ()
    (interactive)
    (helm-find-files-1 org-directory))

(setq org-default-notes-file (concat org-directory "notes.org"))
;;(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(
        ("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
             "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/ijournal.org")
             "* %?\nEntered on %U\n  %i\n  %a")
        ("n" "Note" entry (file+datetree "~/org/note.org")
             "* %?\nEntered on %U\n  %i\n  %a")
        ("o" "OSC" entry (file+datetree "~/org/osc.org")
             "* %?\nOSC:\n")
        )
      )

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(setq org-todo-keywords
       '((sequence "TODO(t)" "WAIT(w@/!)" "SOMETIME(s)" "|" "DONE(d!)" "CANCELED(c@)")))

(require 'ox-publish)
(setq org-publish-project-alist
      '(
        ;; ... add all the components here (see below)...
        ("org-notes"
         :base-directory "~/org/"
         :base-extension "org"
         :publishing-directory "~/public_html/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4             ; Just the default for this project.
         :auto-preamble t
         )
        ("org-static"
         :base-directory "~/org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/public_html/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("org" :components ("org-notes" "org-static"))


        )
      )

;; NOTE: the org-ehtml-docroot value should be fully expanded
(setq org-ehtml-docroot org-directory)
(setq org-ehtml-everything-editable t)

(require 'org-ehtml)
;;(ws-start org-ehtml-handler 8888 "webserver")

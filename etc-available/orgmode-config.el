(req-package org
  :require (org-journal org-install org-protocol org-indent password-store cl)
  :config (setq
   org-log-done t
   org-directory (expand-file-name "~/org/")
   ;;org-directory (expand-file-name "~/share/orgmodegoogle/melit.stevenjoseph@gmail.com/OrgMode/")
   org-from-is-user-regexp nil
   org-log-done t
   org-indent-mode t
   org-mobile-directory (expand-file-name "~/share/Dropbox/MobileOrg/")
   org-mobile-inbox-for-pull (concat org-mobile-directory "mobileorg.org")
   org-return-follows-link t
   org-catch-invisible-edits t
   org-agenda-file-regexp "[^.].*\\.org$"
   org-default-notes-file (concat org-directory "notes.org")
   org-clock-persist 'history
   org-toodledo-userid (password-store-get "internet/toodledo/userid")
   org-toodledo-password (password-store-get "internet/toodledo/password")
   org-toodledo-folder-support-mode t
   org-toodledo-folder-support-mode (quote heading)
   ;org-agenda-files (quote
   ; ("/home/steven/org/todo.org"))
   org-clock-into-drawer t
   org-default-priority 90
   org-ehtml-docroot "~/org/ehtml/"
   org-journal-dir "~/org/journal/"
   org-journal-file-format "%A_%Y%m%d"
   org-lowest-priority 90
   org-emphasis-alist
          (cons '("+" '(:strike-through t :foreground "#121212"))
                            (delete* "+" org-emphasis-alist :key 'car :test 'equal))
   )
  :init
  (progn
    ;;(require 'journal)
    (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
    ;;(define-key global-map "c l" 'org-store-link)
    ;;(define-key global-map "c a" 'org-agenda)
    (org-clock-persistence-insinuate)
    (setq org-todo-keywords
          '((sequence "TODO(t)" "WAIT(w@/!)" "SOMETIME(s)" "STARTED(i)" "|" "DONE(d!)" "CANCELED(c@)" "DEFFERED(f)")))

    ;; I use C-c c to start capture mode
    ;;(global-set-key (kbd "C-c c") 'org-capture)
    (add-to-list 'org-agenda-files org-directory)

    (defun my-org-files ()
      (interactive)
      (helm-find-files-1 org-directory))



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

    (defun org-toggle-todo-and-fold ()
      (interactive)
      (save-excursion
        (org-back-to-heading t) ;; Make sure command works even if point is
        ;; below target heading
        (cond ((looking-at "\*+ TODO")
               (org-todo "DONE")
               (hide-subtree))
              ((looking-at "\*+ DONE")
               (org-todo "TODO")
               (hide-subtree))
              (t (message "Can only toggle between TODO and DONE.")))))

    (define-key org-mode-map (kbd "C-c d") 'org-toggle-todo-and-fold)


    ;;http://doc.norang.ca/org-mode.html

    ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
    (setq org-capture-templates
          (quote (("t" "todo" entry (file "~/org/todo.org")
                   "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                  ("r" "respond" entry (file "~/org/respond.org")
                   "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                  ("n" "note" entry (file "~/org/notes.org")
                   "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                  ("j" "Journal" entry (file+datetree "~/org/ijournal.org")
                   "* %?\n%U\n" :clock-in t :clock-resume t)
                  ("w" "org-protocol" entry (file "~/org/todo.org")
                   "* TODO Review %c\n%U\n" :immediate-finish t)
                  ("m" "Meeting" entry (file "~/org/meetings.org")
                   "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                  ("p" "Phone call" entry (file "~/org/todo.org")
                   "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                  ("h" "Habit" entry (file "~/org/todo.org")
                   "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
                  ("o" "OSC" entry (file+datetree "~/org/osc.org")
                   "* %?\nOSC:\n")
                  ("c" "todo" entry (file "~/org/todo.org")
                   "* TODO %?\nSCHEDULED: %(format-time-string \"<%Y-%m-%d>\")")
                  ("d" "todo" entry (file "~/org/todo.org")
                   "* TODO %?\nDEADLINE: %(format-time-string \"<%Y-%m-%d>\")")
                  )))

    (setq org-agenda-custom-commands
          '(("P" "Projects"   
             ((tags "PROJECT")))
            ("H" "Office and Home Lists"
             ((agenda)
              (tags-todo "OFFICE")
              (tags-todo "HOME")
              (tags-todo "COMPUTER")
              (tags-todo "DVD")
              (tags-todo "READING")))
            ("D" "Daily Action List" 
             ((agenda "" ((org-agenda-ndays 1)
                          (org-agenda-sorting-strategy
                           (quote ((agenda time-up priority-down tag-up) )))
                          (org-deadline-warning-days 0)
                          )))
             )))


    (global-set-key (kbd "C-c a") 'org-agenda)

    )
  )

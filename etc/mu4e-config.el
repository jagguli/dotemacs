(require 'password-store)
;; these are actually the defaults
;; convert org mode to HTML automatically
;;(setq org-mu4e-convert-to-html nil)
;; need this to convert some e-mails properly
;;(setq mu4e-html2text-command "html2text -utf8 -width 72")

(defun email () 
  (interactive)
  (setq mu4e-refile-folder
        (lambda (msg)
          (cond
           ;; messages with football or soccer in the subject go to /football
           ((string-match "football\\|soccer"
                          (mu4e-message-field msg :subject))
            "/football")
           ;; messages sent by me go to the sent folder
           ((find-if
             (lambda (addr)
               (mu4e-message-contact-field-matches msg :from addr))
             mu4e-user-mail-address-list)
            mu4e-sent-folder)
           ;; everything else goes to /archive
           ;; important to have a catch-all at the end!
           (t  "/inbox"))))
  ;; sending mail -- replace USERNAME with your gmail username
  ;; also, make sure the gnutls command line utils are installed
  ;; package 'gnutls-bin' in Debian/Ubuntu
  
  (require 'smtpmail)

  ;; something about ourselves
  (if (string-match "^.*.iress.com.au" system-name )
      (progn
        (setq
         user-mail-address (password-store-get "iress/user")
         user-full-name  "Steven Joseph"
         message-signature nil
         ;;message-send-mail-function 'smtpmail-send-it
         message-send-mail-function 'message-send-mail-with-iress-sendmail
         ;;smtpmail-stream-type 'plain
         ;;smtpmail-default-smtp-server "localhost"
         ;;smtpmail-smtp-server "localhost"
         ;;smtpmail-smtp-service 1025)
         )
        )
    (progn
      (setq
       user-mail-address "steven@stevenjoseph.in"
       user-full-name  "steven@stevenjoseph.in"
       message-signature nil)
      )
    )
 
  
  (when (not (featurep 'mu4e))
    (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e/")
 
    (require 'mu4e)
    (require 'org-mu4e)
 
    ;; defaults
 
    (setq
     ;;mu4e-maildir       "~/.local/share/local-mail"   ;; top-level Maildir
     mu4e-maildir       "~/mail/iress-local"   ;; top-level Maildir
     mu4e-maildir       "/home/steven/.local/share/.local-mail.directory"   ;; top-level Maildir
     mu4e-sent-folder   "/sent-mail"       ;; folder for sent messages
     mu4e-drafts-folder "/drafts"     ;; unfinished messages
     mu4e-trash-folder  "/trash"      ;; trashed messages
     )
     ;;mu4e-refile-folder "/archive")   ;; saved messages
 
    
    ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
    (setq mu4e-sent-messages-behavior 'delete)
 
    ;; setup some handy shortcuts
    ;; you can quickly switch to your Inbox -- press ``ji''
    ;; then, when you want archive some messages, move them to
    ;; the 'All Mail' folder by pressing ``ma''.
 
    (setq mu4e-maildir-shortcuts
          '( ("/inbox"               . ?i)
             ("/manup"   . ?u)
             ("/me"   . ?m)
             ;; ("/gmail/[Gmail].Sent Mail"   . ?s)
             ;; ("/gmail/[Gmail].Trash"       . ?t)
             ("/osc"    . ?o)))
 
    ;; allow for updating mail using 'U' in the main view:
    ;; I have this running in the background anyway
    ;; (setq mu4e-get-mail-command "offlineimap")
 
 
    ;; don't keep message buffers around
    (setq message-kill-buffer-on-exit t)
 
    ;; show images
    (setq mu4e-show-images t)
 
    ;; use imagemagick, if available
    (when (fboundp 'imagemagick-register-types)
      (imagemagick-register-types))
 
    ;;; message view action
    (defun mu4e-msgv-action-view-in-browser (msg)
      "View the body of the message in a web browser."
      (interactive)
      (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
            (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
        (unless html (error "No html part for this message"))
        (with-temp-file tmpfile
          (insert
           "<html>"
           "<head><meta http-equiv=\"content-type\""
           "content=\"text/html;charset=UTF-8\">"
           html))
        (browse-url (concat "file://" tmpfile))))
 
    (add-to-list 'mu4e-view-actions
                 '("View in browser" . mu4e-msgv-action-view-in-browser) t)
 
    ;; convert org mode to HTML automatically
    (setq org-mu4e-convert-to-html t)
 
    ;; need this to convert some e-mails properly
    ;; (setq mu4e-html2text-command "html2text -utf8 -width 72")
    (setq mu4e-html2text-command "html2text ")
  )
  (mu4e)
)
 
(defalias 'org-mail 'org-mu4e-compose-org-mode)

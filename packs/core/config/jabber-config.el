(live-add-pack-lib "emacs-jabber")
(require 'jabber-autoloads)
(require 'jabber-libnotify)
(require 'keepassdb)
(setq jabber-alert-message-wave "~/.sounds/computerbeep_9.wav")
(setq jabber-invalid-certificate-servers '("mel-imsrv1" "mel-imsrv1.devel.iress.com.au"))

(defun jabber ()
  (interactive)
  (if (string-match "^.*.iress.com.au" system-name )
      (progn
        (setq jabber-account-list `((,(keepass-get "/jabber/iress" "username")
                                     (:password . ,(keepass-get "/jabber/iress" "password"))))))
    (progn
      (setq jabber-account-list `((,(keepass-get "/jabber/melit" "username")
                                   (:password . ,(keepass-get "/jabber/melit" "password"))
                                   (:network-server . "talk.google.com")
                                   (:connection-type . ssl)
                                   (:port . 443))
                                  (,(keepass-get "/jabber/stevenjose" "username")
                                   (:password . ,(keepass-get "/jabber/stevenjose" "password"))
                                   (:network-server . "talk.google.com")
                                   (:connection-type . ssl)
                                   (:port . 443))))
      ))
  (jabber-connect-all)
  (switch-to-buffer "*-jabber-*"))


(defun egh:jabber-google-groupchat-create ()
  (interactive)
  (let ((group (apply 'format "private-chat-%x%x%x%x%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x%x%x%x%x%x%x%x%x@groupchat.google.com"
                      (mapcar (lambda (x) (random x)) (make-list 32 15))))
        (account (jabber-read-account)))
    (jabber-groupchat-join account group (jabber-muc-read-my-nickname account group) t)))


(defun jabber-notify-tray (FROM BUFFER TEXT TITLE)
  (interactive)
  (message (format "%s, %s, %s, %s" FROM BUFFER TEXT TITLE))
)
(add-hook 'jabber-message-hooks 'jabber-notify-tray)

(defun jabber-tray-onview
  (interactive)
  (message "clear notifications"))

(defun tray-setup-change-hooks ()
  (interactive)
  (let ()
         ;; make the change hooks local to this buffer as we don't
;; want
    ;; this code working in all buffers
    (make-local-hook 'before-change-functions)
    (add-hook 'before-change-functions
              'jabber-tray-onview
              t
              t)))
(add-hook 'jabber-chat-mode-hook 'tray-setup-change-hooks)

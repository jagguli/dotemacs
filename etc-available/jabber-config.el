(add-user-lib "emacs-jabber")
(add-user-lib "emacs-jabber-otr")

(req-package
  jabber-libnotify
  :require (jabber-otr password-store)
  :defer t
  :init
  (progn
    (setq
     jabber-history-enabled t
     jabber-use-global-history nil
     jabber-backlog-number 40
     jabber-backlog-days 30
     jabber-default-status "How can I help ?"
     jabber-default-show "chat"
     jabber-default-priority 300
     jabber-silent-mode nil
     jabber-alert-info-message-hooks (quote (jabber-info-tmux jabber-info-echo))
     jabber-alert-message-hooks (quote (jabber-message-libnotify))
     jabber-alert-message-wave "~/.sounds/message-new-instant.wav"
     jabber-auto-reconnect t
     jabber-autoaway-priority 0
     jabber-autoaway-verbose t
     jabber-autoaway-xa-priority 0
     jabber-backlog-days 30
     jabber-backlog-number 40
     jabber-default-show "chat"
     jabber-default-status "can I automate it ?"
     jabber-history-enable-rotation t
     jabber-history-enabled t
     jabber-history-muc-enabled t
     jabber-invalid-certificate-servers
     (quote
      ("mel-imsrv1" "mel-imsrv1.devel.iress.com.au" "iress.com.au"))
     jabber-keepalive-interval 30
     jabber-libnotify-method (quote dbus)
     jabber-mode-line-mode t
     jabber-post-connect-hooks
     (quote
      (
       ;;sr-jabber-post-connect-func
       jabber-send-current-presence
       jabber-muc-autojoin
       jabber-keepalive-start
       ;;jabber-whitespace-ping-start
       jabber-vcard-avatars-find-current
       ;;sauron-jabber-start
       )
      )
     jabber-roster-line-format "%c %-25n %u %-8s  %S"
     jabber-show-offline-contacts nil
     jabber-use-auth-sources t
     jabber-use-global-history nil
     password-cache-expiry 300
     )

    ;;(setq jabber-default-show , jabber-default-status and jabber-default-priority
    (defun jabber ()
      (interactive)
      (if (string-match "^.*.iress.com.au" system-name )
          (progn
            (setq jabber-account-list `((,(password-store-get "iress/user")
                                         (:network-server . ,(password-store-get "iress/jabber"))
                                         (:password . ,(password-store-get "iress/default")))))
            )
        (progn
          (setq jabber-account-list
                `(
                  ;;(,(password-store-get "internet/facebook")
                  ;; (:password . ,(password-store-get "internet/facebook/password"))
                  ;; (:network-server . ,(password-store-get "internet/facebook/xmpp"))
                  ;; (:port . 5222))
                  ;;;(,(password-store-get "internet/google/melit" )
                  ; (:password . ,(password-store-get "internet/google/melit/password"))
                  ; (:network-server . ,"talk.google.com")
                  ; (:connection-type . ssl)
                  ; (:port . 443))
                  (,(password-store-get "iress/jabber/user")
                   (:network-server . ,(password-store-get "iress/jabber/proxy"))
                   (:password . ,(password-store-get "iress/default")))
                  )
                )
          ))
      (jabber-connect-all)
      (switch-to-buffer "*-jabber-roster-*")
      )

    
    (defun egh:jabber-google-groupchat-create ()
      (interactive)
      (let ((group (apply 'format "private-chat-%x%x%x%x%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x%x%x%x%x%x%x%x%x@groupchat.google.com"
                          (mapcar (lambda (x) (random x)) (make-list 32 15))))
            (account (jabber-read-account)))
        (jabber-groupchat-join account group (jabber-muc-read-my-nickname account group) t)))


    (require 'dbus)                                                                      
    (defvar z-jabber-bus-name "org.emacs.JabberEl" "The name on the session bus")
    (defvar z-jabber-bus-object "/org/emacs/JabberEl" "The name of the object you're talking to")
    (defvar z-jabber-interface "org.emacs.JabberEl" "The interface your object implements")

    (defun z-jabber-send-tray-test ()
      "Send a message using DBus"
      (interactive)
      (dbus-call-method-asynchronously :session z-jabber-bus-name z-jabber-bus-object z-jabber-interface "activity" 'message jabber-activity-count-string))

    (defun z-jabber-send-tray-activity-update ()
      (message "activity-update")
      (z-jabber-send-tray))
    (defun z-jabber-send-tray-activity ()
      (message "activity")
      (z-jabber-send-tray))
    (defun z-jabber-send-tray-chatmode ()
      (message "chatmode")
      (z-jabber-send-tray))

    (defun z-jabber-send-tray-chatsend (text id)
      (message (format "chatmode: %s %s" text id))
      (dbus-call-method-asynchronously :session z-jabber-bus-name 
                                       z-jabber-bus-object z-jabber-interface 
                                       "clear" 'message)
      (list)
      )

    (defun z-jabber-send-tray ()
      "Send a message using DBus"
      (dbus-call-method-asynchronously :session z-jabber-bus-name z-jabber-bus-object z-jabber-interface "activity" 'message jabber-activity-count-string))

    (defun jabber-notify-tray (FROM BUFFER TEXT TITLE)
      (message (format "Notify Tray: %s, %s, %s, %s" FROM BUFFER TEXT TITLE))
      (dbus-call-method-asynchronously :session z-jabber-bus-name z-jabber-bus-object z-jabber-interface "message" 'message FROM "" TEXT TITLE))

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

    (add-hook 'jabber-message-hooks 'jabber-notify-tray)
    (add-hook 'jabber-activity-update-hooks 'z-jabber-send-tray-activity-update)
    (add-hook 'jabber-activity-hooks 'z-jabber-send-tray-activity)
    (add-hook 'jabber-chat-mode-hook 'z-jabber-send-tray-chatmode)
    (add-hook 'jabber-chat-send-hooks 'z-jabber-send-tray-chatsend)

    (setq jabber-chat-header-line-format
          '(" " (:eval (jabber-jid-displayname jabber-chatting-with))
            " " (:eval (jabber-jid-resource jabber-chatting-with)) "\t";
            (:eval (let ((buddy (jabber-jid-symbol jabber-chatting-with)))
                     (propertize
                      (or
                       (cdr (assoc (get buddy 'show) jabber-presence-strings))
                       (get buddy 'show))
                      'face
                      (or (cdr (assoc (get buddy 'show) jabber-presence-faces))
                          'jabber-roster-user-online))))
            "\t" (:eval (get (jabber-jid-symbol jabber-chatting-with) 'status))
            (:eval (unless (equal "" *jabber-current-show*)
                     (concat "\t You're " *jabber-current-show*
                             " (" *jabber-current-status* ")")))))

    (add-hook 'jabber-chat-mode-hook 'goto-address)
    (add-hook 'jabber-post-connect-hooks 'jabber-send-default-presence)
    (add-hook 'jabber-post-connect-hooks 'jabber-autoaway-start)
    

    )
)

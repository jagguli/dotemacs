(live-add-pack-lib "emacs-jabber")
(require 'jabber-autoloads)
(require 'jabber-libnotify)
(require 'jabber-tmux)
(require 'keepassdb)
(setq jabber-alert-message-wave "~/.sounds/computerbeep_9.wav")
(setq jabber-invalid-certificate-servers '("mel-imsrv1" "mel-imsrv1.devel.iress.com.au" "iress.com.au"))

(defun jabber ()
  (interactive)
  (if (string-match "^.*.iress.com.au" system-name )
      (progn
        (setq jabber-account-list `((,(keepass-get "/iress/jabber" "username")
                                     (:network-server . ,(keepass-get "/iress/jabber" "url"))
                                     (:password . ,(keepass-get "/iress/default" "password")))))
        (jabber-connect-all)
        )
    (progn
      (setq jabber-account-list `((,(keepass-get "/facebook/xmpp" "username")
                                   (:password . ,(keepass-get "/facebook/xmpp" "password"))
                                   (:network-server . ,(keepass-get "/facebook/xmpp" "url"))
                                   (:port . 5222))
                                  (,(keepass-get "/google/jabber/melit" "username")
                                   (:password . ,(keepass-get "/google/jabber/melit" "password"))
                                   (:network-server . ,(keepass-get "/google/jabber/melit" "url"))
                                   (:connection-type . ssl)
                                   (:port . 443))
                                  ))
      ))
  (switch-to-buffer "*-jabber-roster-*"))


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

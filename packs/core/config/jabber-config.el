(live-add-pack-lib "emacs-jabber")
(require 'jabber-autoloads)
(require 'jabber-libnotify)
;;(add-hook 'jabber-post-connect-hooks 'jabber-keepalive-start)
;;(setq jabber-keepalive-interval 30)
(setq jabber-invalid-certificate-servers '("mel-imsrv1"))
(setq jabber-account-list
      '(("stevenjose@gmail.com"
         (:network-server . "talk.google.com")
         (:connection-type . ssl))
("steven.joseph@mel-imsrv1"
         (:network-server . "mel-imsrv1")
         (:connection-type . starttls)
         (:port . 5222))
        ))

(setq jabber-alert-message-wave "~/.sounds/computerbeep_9.wav")

(defun jabber ()
  (interactive)
  (jabber-connect)
      (switch-to-buffer "*-jabber-*"))


(defun egh:jabber-google-groupchat-create ()
  (interactive)
  (let ((group (apply 'format "private-chat-%x%x%x%x%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x%x%x%x%x%x%x%x%x@groupchat.google.com"
                      (mapcar (lambda (x) (random x)) (make-list 32 15))))
        (account (jabber-read-account)))
    (jabber-groupchat-join account group (jabber-muc-read-my-nickname account group) t)))


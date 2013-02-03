(live-add-pack-lib "emacs-jabber")
(require 'jabber-autoloads)
(setq jabber-account-list
      '(("stevenjose@gmail.com"
         (:network-server . "talk.google.com")
                (:connection-type . ssl))))

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


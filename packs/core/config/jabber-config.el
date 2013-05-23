(live-add-pack-lib "emacs-jabber")
(require 'jabber-autoloads)
(require 'jabber-libnotify)
(require 'netrc)
;;(setq-default
;; comint-output-filter-functions
;; '(comint-watch-for-password-prompt))
;;(setq
;; comint-password-prompt-regexp
;; "\\(\\([Oo]ld \\|[Nn]ew \\|^\\)[Pp]assword\\|Enter password\\):\\s *\\'")
(add-hook 'comint-output-filter-functions
                              'comint-strip-ctrl-m)
;;https://github.com/ardumont/my-org-files/blob/master/articles/emacs-jabber.org
;; auth info format
;;machine jabber login i<jabberid> password <pass>
(setq keepass (read-passwd "Enter keepass:"))
(if (string-match "^.*.iress.com.au" system-name )
    (progn
      (setq cred (netrc-machine (netrc-parse "~/.netrc/authinfo") "jabber" t))
      (setq login (shell-command-to-string (format "TERM= keepassc.py ~/Dropbox/keepass.kdb -p %s -g /jabber/iress -k username" keepass)))
      (setq server (shell-command-to-string (format "TERM= keepassc.py ~/Dropbox/keepass.kdb -p %s -g /jabber/iress -k url" keepass)))
      (setq password (shell-command-to-string (format "TERM= keepassc.py ~/Dropbox/keepass.kdb -p %s -g /jabber/iress -k password" keepass)))
      (setq jabber-account-list `((,login
                                   (:password . ,password)
                                   (:network-server . ,server)
                                   (:connection-type . starttls)
                                   (:port . 5222)))))
  (progn
    (setq cred1 (netrc-machine (netrc-parse "~/.netrc/authinfo") "jabber1" t))
    (setq cred2 (netrc-machine (netrc-parse "~/.netrc/authinfo") "jabber2" t))
    (setq login1  (shell-command-to-string (format "TERM= keepassc.py ~/Dropbox/keepass.kdb -p %s -g /jabber/melit -k username" keepass)))
    (setq jabber-account-list `((,login1
                                 (:password . ,(netrc-get cred1 "password"))
                                 (:network-server . "talk.google.com")
                                 (:connection-type . ssl)
                                 (:port . 443))
                                (,(netrc-get cred2 "login")
                                 (:password . ,(netrc-get cred2 "password"))
                                 (:network-server . "talk.google.com")
                                 (:connection-type . ssl)
                                 (:port . 443))))))
;;(setq jabber-invalid-certificate-servers '("mel-imsrv1"))
;;(setq jabber-account-list
;;      '(
;;("melit.stevenjoseph@gmail.com"
;;         (:network-server . "talk.google.com")
;;         (:port . 443)
;;         (:connection-type . ssl))
;;        ("steven.joseph@mel-imsrv1"
;;         (:network-server . "mel-imsrv1")
;;         (:connection-type . starttls)
;;         (:port . 5222))
;;        ))      
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


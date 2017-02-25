(require 'password-store)

(setq gnus-select-method
      '(nnimap "iress"
               (nnimap-address "localhost")
               (nnimap-server-port 1143)
               (nnimap-stream network)))
;;(setq gnus-secondary-select-methods
;;      '(nnimap "gmail"
;;               (nnimap-address "imap.gmail.com")
;;               (nnimap-server-port 993)
;;               (nnimap-stream ssl)))


(defadvice gnus (after gnus-init (arg char) activate)
  (setq message-send-mail-function 'smtpmail-send-it
        smtpmail-starttls-credentials '(("smtp.gmail.com" 465 nil nil))
        smtpmail-auth-credentials '(("smtp.gmail.com" 465
                                     (password-store-get "streethawk/google/password") nil))
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 465
        gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]"))

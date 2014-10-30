(require 'password-store)

(setq gnus-select-method
      '(nnimap "iress"
               (nnimap-address "email2.iress.com.au")
               (nnimap-server-port 443)
               (nnimap-stream ssl)))
(setq gnus-secondary-select-methods
      '(nnimap "gmail"
               (nnimap-address "imap.gmail.com")
               (nnimap-server-port 993)
               (nnimap-stream ssl)))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
                                    (password-store-get "internet/google/stevenjoseph.in") nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

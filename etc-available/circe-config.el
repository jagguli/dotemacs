(req-package circe
  :require (
            password-store
            )
  :config
  (setq circe-network-options
        `(("Freenode"
           :tls t
           :nick ,(password-store-get "irc/freenode/username")
           :password ,(password-store-get "irc/freenode/password")
           :sasl-username ,(password-store-get "irc/freenode/username")
           :sasl-password ,(password-store-get "irc/freenode/password")
           :channels (
                      "#emacs-circe"
                      "#emacs"
                      "#salt"
                      )
           )))
  :init
  (progn
    (message "circe-config loaded"))
  )

(req-package circe
  :require (
            password-store
            )
  :config
  (setq
   circe-reduce-lurker-spam t
   lui-time-stamp-position 'right-margin
   lui-time-stamp-format "%H:%M"
   lui-flyspell-p t
   lui-track-bar-behavior 'before-switch-to-buffer
   circe-format-say "{nick:s}: {body}"
   circe-server-max-reconnect-attempts 1000
   lui-flyspell-alist '(
                        ("#hamburg" "german8")
                        (".*" "american")
                        )
   circe-network-options
   `(
     ("Freenode"
      :tls t
      :nick ,(password-store-get "irc/freenode/username")
      :password ,(password-store-get "irc/freenode/password")
      :sasl-username ,(password-store-get "irc/freenode/username")
      :sasl-password ,(password-store-get "irc/freenode/password")
      :channels (
                 "#emacs-circe"
                 "#emacs"
                 "#salt"
                 "#riak"
                 "#python"
                 "#notmuch"
                 )
      )
     ("OFTC"
      :tls t
      :nick ,(password-store-get "irc/oftc/username")
      :password ,(password-store-get "irc/oftc/password")
      :sasl-username ,(password-store-get "irc/oftc/username")
      :sasl-password ,(password-store-get "irc/oftc/password")
      :channels (
                 "#qtile"
                 )
      )
     )
   )
  :init
  (progn
    ;;(defun circe-network-connected-p (network)
    ;;  "Return non-nil if there's any Circe server-buffer whose
    ;;    `circe-server-netwok' is NETWORK."
    ;;  (catch 'return
    ;;    (dolist (buffer (circe-server-buffers))
    ;;      (with-current-buffer buffer
    ;;        (if (string= network circe-server-network)
    ;;            (throw 'return t))))))

    ;;(defun circe-maybe-connect (network)
    ;;  "Connect to NETWORK, but ask user for confirmation if it's
    ;;    already been connected to."
    ;;  (interactive "sNetwork: ")
    ;;  (if (or (not (circe-network-connected-p network))
    ;;          (y-or-n-p (format "Already connected to %s, reconnect?" network)))
    ;;      (circe network)))
    ;;(defun irc ()
    ;;  "Connect to IRC"
    ;;  (interactive)
    ;;  (circe-maybe-connect "Freenode")
    ;;  ;;(circe "Bitlbee")
    ;;  ;;(circe "IRCnet")
    ;;  )
    (load "lui-logging" nil t)
    (enable-lui-logging-globally)
    (enable-circe-color-nicks)
    (add-hook 'lui-mode-hook 'my-circe-set-margin)
    (defun my-circe-set-margin ()
      (setq right-margin-width 5))
    (circe-set-display-handler "JOIN" (lambda (&rest ignored) nil))
    (circe-set-display-handler "QUIT" (lambda (&rest ignored) nil))
    (enable-lui-track-bar)
    (circe-lagmon-mode)
    (add-hook 'circe-chat-mode-hook 'my-circe-prompt)
    (defun my-circe-prompt ()
      (lui-set-prompt
       (concat (propertize (concat (buffer-name) ">")
                           'face 'circe-prompt-face)
               " ")))
    (message "circe-config loaded")
  )
)
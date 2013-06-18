(require 'password-cache)

(defcustom keepassdb-path
  "~/Dropbox/keepass/keepass.kdb" "Keepass db location")

(defcustom keepassdb-command
  "TERM= keepassc.py" "Command to call.")

(defun keepass-get-command (path key)
  (format "%s %s -p %s -g %s -k %s"
          keepassdb-command keepassdb-path
          (password-read-and-add "Enter pass for keepass" "keepass")
          path key))

(defun keepass-get (path key)
  (replace-regexp-in-string "\n$" ""
                            (shell-command-to-string (keepass-get-command path key))))

(defun test-keepass-get ()
  (interactive)
  (message (keepass-get-command "/devices/iress" "password"))
  (message (keepass-get "/jabber/iress" "password" )))

(provide 'keepassdb)

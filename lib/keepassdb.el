(require 'password-cache)

(defcustom keepassdb-path
  "~/share/Dropbox/keepass/keepass.kdbx" "Keepass db location")

(defcustom keepassdb-command
  "KDE_SESSION_ID=1 TERM= keepassc2.py" "Command to call.")

(defun keepass-get-command (path key)
  (format "%s %s -p %s -g %s -k %s 2>/dev/null"
          keepassdb-command keepassdb-path
          (password-read-and-add "Enter pass for keepass" "keepass")
          path key))

(defun keepass-get (path key)
  (replace-regexp-in-string "\n$" ""
                            (shell-command-to-string (keepass-get-command path key))))

(defun test-keepass-get ()
  (interactive)
  (message (keepass-get-command "iress/default" "Password"))
  (message (keepass-get "iress/default" "Password" )))

(provide 'keepassdb)

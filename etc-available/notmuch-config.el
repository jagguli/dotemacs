(req-package notmuch
   :require (notmuch-pick notmuch-address password-cache password-store dash)
   :init
   (progn
     (notmuch-address-message-insinuate)

     (defun notmuch-config ()
       (interactive)
       (setq
        notmuch-wash-wrap-lines-length 70
        notmuch-search-result-format
        '(
          ("date" . "%12s | ")
          ("authors" . "%-50s ")
          ("subject" . "%-80s")
          ("tags" . "[%s]")
          )
        notmuch-tree-result-format
        '(("date" . "%12s  ")
          ("authors" . "%-15s")
          ((("tree" . "%s ")
            ("subject" . "%s"))
           . " %-54s ")
          ("tags" . "[%s]")
          )
        notmuch-tree-show-out t

        send-mail-function (quote mailclient-send-it)
        message-sendmail-f-is-evil 't
        sendmail-program "/usr/sbin/msmtp"
        ;;need to tell msmtp which account we're using
        message-send-mail-function 'message-send-mail-with-sendmail
        )
       (if (string-match ".*\.iress\.com\.au" system-name )
           (progn 
             (setq notmuch-wash-original-regexp "^\\(From: .*\\|.* writes:\\)$")
             (setq notmuch-wash-citation-lines-prefix 0)
             (setq user-mail-address (concat (password-store-get "iress/user") "@iress.com.au"))

             (setq notmuch-address-command "~/.bin/mutt_ldap.py"))
         (progn
           (setq notmuch-address-command "~/.bin/notmuch-goobook"))))

     (defun cg-feed-msmtp ()
       (if (message-mail-p)
           (save-excursion
             (let* ((from
                     (save-restriction
                       (message-narrow-to-headers)
                       (message-fetch-field "from")))
                    (account
                     (cond
                      ;; I use email address as account label in ~/.msmtprc
                      ((string-match "melit.stevenjoseph@gmail.com" from) "melit")
                      ((string-match "stevenjose@gmail.com" from) "stevenjose")
                      ((string-match "steven@stevenjoseph.in" from) "stevenjoseph.in")
                      ;; Add more string-match lines for your email accounts
                      ((string-match "steven.joseph@iress.com.au" from) "iress"))))
               (setq message-sendmail-extra-arguments (list '"-a" account))))))

     (setq message-sendmail-envelope-from 'header)
     (add-hook 'message-send-mail-hook 'cg-feed-msmtp)
     (notmuch-config)

     (defun notmuch-search-toggle-tags (tags)
       "toggle tags for thread"
       (interactive)
       (if (cl-subsetp tags (notmuch-search-get-tags) :test 'string=)
           (notmuch-search-tag (mapcar (lambda (x) (concat "-" x)) tags))
         (notmuch-search-tag (mapcar (lambda (x) (concat "+" x)) tags)))
       (next-line)
       )
     )
     (define-key notmuch-search-mode-map "d"
       (lambda ()
         "toggle deleted tag for message"
         (interactive)
         (notmuch-search-toggle-tags '("deleted"))))

     (define-key notmuch-show-mode-map "d"
       (lambda ()
         "toggle deleted tag for message"
         (interactive)
         (notmuch-search-toggle-tags '("deleted"))))


     (define-key notmuch-search-mode-map "x"
       (lambda ()
         "toggle the unread tag for message"
         (interactive)
         (notmuch-search-toggle-tags '("unread"))))

     (define-key notmuch-show-mode-map "F"
       (lambda ()
         "toggle the flagged tag for message"
         (interactive)
         (notmuch-search-toggle-tags '("flagged"))))
     (define-key notmuch-search-mode-map "F"
       (lambda ()
         "toggle the flagged tag for message"
         (interactive)
         (notmuch-search-toggle-tags '("flagged"))))

     (define-key notmuch-show-mode-map "b"
       (lambda (&optional address)
         "Bounce the current message."
         (interactive "sBounce To: ")
         (notmuch-show-view-raw-message)
         (message-resend address)))

     (defvar notmuch-hello-refresh-count 0)

     (defun notmuch-hello-refresh-status-message ()
       (unless no-display
         (let* ((new-count
                 (string-to-number
                  (car (process-lines notmuch-command "count"))))
                (diff-count (- new-count notmuch-hello-refresh-count)))
           (cond
            ((= notmuch-hello-refresh-count 0)
             (message "You have %s messages."
                      (notmuch-hello-nice-number new-count)))
            ((> diff-count 0)
             (message "You have %s more messages since last refresh."
                      (notmuch-hello-nice-number diff-count)))
            ((< diff-count 0)
             (message "You have %s fewer messages since last refresh."
                      (notmuch-hello-nice-number (- diff-count)))))
           (setq notmuch-hello-refresh-count new-count))))

     (add-hook 'notmuch-hello-refresh-hook 'notmuch-hello-refresh-status-message)



     (defun color-inbox-if-unread ()
       (interactive)
       (save-excursion
         (goto-char (point-min))
         (let ((cnt (car (process-lines "notmuch" "count" "tag:inbox and tag:unread"))))
           (when (> (string-to-number cnt) 0)
             (save-excursion
               (when (search-forward "inbox" (point-max) t)
                 (let* ((overlays (overlays-in (match-beginning 0) (match-end 0)))
                        (overlay (car overlays)))
                   (when overlay
                     (overlay-put overlay 'face '((:inherit bold) (:foreground "green")))))))))))

     (add-hook 'notmuch-hello-refresh-hook 'color-inbox-if-unread)

     ;;(setq notmuch-search-line-faces
     ;;      '(("deleted" . (:foreground "red" :background "blue"))
     ;;        ("unread" . (:foreground "green"))
     ;;        ("flagged" . (:foreground "lightgreen" :background "darkslategrey"))))

     (add-hook 'notmuch-show-hook 
               (lambda ()
                 (interactive)
                 ;;(notmuch-show-mark-read)
                                        ;(call-interactively 'notmuch-show-open-or-close-all) 
                 (notmuch-show-tag-all  '("-unread"))
                 ;;(notmuch-show-collapse-all)
                 ))

     (defun notmuch-show-collapse-all ()
       (interactive)
       (setq current-prefix-arg '(4))
       (call-interactively 'notmuch-show-open-or-close-all) 
       )
     (defun notmuch-attach-file()
       (interactive)
       (mml-attach-file))

     (defun open-in-chrome ()
       (interactive)
       (message "open-in-chrome")
       (notmuch-show-pipe-message nil "/home/steven/.bin/mutt_chrome.py"))
     (defun open-in-kmail ()
       (interactive)
       (message "open in kmail")
       (shell-command (concat "kmail --view file://" (notmuch-show-get-filename)))
       )

     (defun notmuch-toggle-all-headers ()
       (interactive)
       (save-excursion
         (goto-char (point-min))
         (loop do (notmuch-show-toggle-visibility-headers)
               until (not (notmuch-show-goto-message-next))))
       (force-window-update))

     (define-key notmuch-show-mode-map "H" 'notmuch-toggle-all-headers)
     (define-key notmuch-show-mode-map "a" 'notmuch-show-collapse-all)
     (define-key notmuch-show-mode-map "r" 'notmuch-show-reply)
     (define-key notmuch-show-mode-map "R" 'notmuch-show-reply-sender)
     (define-key notmuch-search-mode-map "r" 'notmuch-search-reply-to-thread)
     (define-key notmuch-search-mode-map "R" 'notmuch-search-reply-to-thread-sender)
     (define-key notmuch-show-mode-map "o" 'open-in-chrome)

     ;; (defun match-strings-all (&optional string)
     ;;    "Return the list of all expressions matched in last search.
     ;;  
     ;;  STRING is optionally what was given to `string-match'."
     ;;    (let ((n-matches (1- (/ (length (match-data)) 2))))
     ;;      (mapcar (lambda (i) (match-string i string))
     ;;              (number-sequence 0 n-matches))))
     ;;
     ;;(defun notmuch-show-picture-headers ()
     ;;  "insert image near email address"
     ;;(message "calling")
     ;;  (goto-char (point-min))
     ;;    (message (buffer-substring (match-beginning) (match-end)))
     ;;
     ;;    ))
     ;;
     ;;(add-hook 'notmuch-show-hook 'notmuch-show-picture-headers t)

     (defun notmuch-import-calendar (cal)
       (interactive 
        (list
         (completing-read "Choose one: "
                          (split-string
                           (shell-command-to-string
                            "~/.bin/gcalcli_api.py list") ":"))))
       (setq  temp_file (make-temp-file "meeting"))
       (defun my-mm-save-part (handle)
         (mm-save-part-to-file handle temp_file))
       (notmuch-show-apply-to-current-part-handle #'my-mm-save-part)
       (message (shell-command-to-string
                 (format "gcalcli import --nocolor --calendar %s %s" cal temp_file)))
       (message "Done")
       )

     (defun write-string-to-file (string file)
       (interactive "sEnter the string: \nFFile to save to: ")
       (with-temp-file file
         (progn 
           (insert-file file)
           (open-line 1)
           (insert string))))


     (defun add-to-mailers ()
       (interactive)
       (if (notmuch-show-get-from)
           (progn 
             (message (notmuch-show-get-from))
             (write-string-to-file 
              (format "%s" (notmuch-show-get-from))
              (expand-file-name "~/.mailers")))))

     )

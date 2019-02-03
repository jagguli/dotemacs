(req-package notmuch
  :require (
            password-cache
            password-store
            dash
            addressbook-bookmark
            ;smtpmail-async
            ;;auth-password-store
            )
  :init
  (progn
    (helm-mode)
    ;;(auth-pass-enable)
    (defun my-async-smtpmail-send-it ()
      (let ((to          (message-field-value "To"))
            (buf-content (buffer-substring-no-properties
                          (point-min) (point-max))))
        ;;(notifications-notify
        ;; :title (format "Delivering message to %s..." to)
        ;; :timeout 5
        ;; )
        (async-smtpmail-send-it)
        ;;(notifications-notify
        ;; :title (format "Sent message to %s..." to)
        ;; :timeout 5
        ;; )
        (message "after smtpsend ")))
    (add-hook
     'notmuch-message-mode-hook
     (lambda ()
       (flyspell-mode)))
    (setq
     notmuch-saved-searches
      (quote
       (
        (:name "inbox" :query "tag:inbox and not (tag:misc) and not (tag:mailers) and date:30d..0s" :key "i")
        (:name "all" :query "date:1M..now" :key "a")
        (:name "streethawk" :query "date:1M..now and not tag:mailers and (to:steven@streethawk.com or to:steven@streethawk.co) and tag:inbox" :key "S")
        (:name "stevenjoseph.in" :query "date:1M..now and to:steven@stevenjoseph.in" :key "j")
        (:name "melit" :query "date:1M..now and to:melit.stevenjoseph@gmail.com" :key "j")
        (:name "important" :query "tag:important" :key "I")
        (:name "sentry" :query "tag:sentry")
        (:name "pullrequests" :query "tag:pullrequests" :key "p")
        (:name "bitbucket" :query "tag:bitbucket")
        (:name "hawk" :query "tag:hawk")
        (:name "jira" :query "tag:jira")
        (:name "unread" :query "tag:unread")
        (:name "sent/replied" :query "tag:sent tag:replied and date:30d..0s")
        (:name "nomailers" :query "not tag:mailers")
        (:name "misc" :query "tag:misc")
        (:name "sent" :query "tag:sent")
        (:name "drafts" :query "tag:draft" :key "d")
        (:name "last30days" :query "date:30d..0s")
        (:name "me" :query "tag:me" :key "m")
        (:name "unread_me" :query "tag:me and tag:unread")
        (:name "calendar" :query "mimetype:text/calendar" :key "c")
        (:name "notifications" :query "tag:sentry or tag:bitbucket or tag:jira or tag:pullrequests or mimetype:text/calendar" :key "n")
        ))
     notmuch-wash-wrap-lines-length 70
     notmuch-tree-show-out t
     user-full-name "Steven Joseph"
     ;;auth-source-debug t
     notmuch-search-result-format
     '(
       ("date" . "%12s│ ")
       ("subject" . "%-100s")
       ("authors" . "%-60s")
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
     notmuch-search-line-faces
     (quote
      (("deleted" :foreground "red" :background "grey")
       ("important" :foreground "yellow")
       ("unread" :foreground "green")
       ("today" :foreground "green" :background "color-232")
       ("flagged" :foreground "magenta")
       ("draft" :foreground "brightblue")
       ("me" :weight bold :foreground "white")
       ("INBOX" :foreground "color-243")
       )
      )
     message-sendmail-envelope-from 'header
     notmuch-address-selection-function
      (lambda (prompt collection initial-input)
        (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history))

     ;;(lambda (prompt collection initial-input)
     ;;  (completing-read prompt
     ;;                   (cons initial-input collection)
     ;;                   nil t nil 'notmuch-address-options))
     ;;NOTE smtp auth in .authinfo.gpg
     ;;send-mail-function 'smtpmail-send-it
     send-mail-function 'my-async-smtpmail-send-it
     ;;smtpmail-local-domain "streethawk.com"
     ;;smtpmail-sendto-domain "streethawk.com"
     smtpmail-debug-info t
     smtpmail-debug-verb t
     ;;mail-user-agent 'message-user-agent
     smtpmail-stream-type 'ssl
     smtpmail-smtp-server "smtp.gmail.com"
     smtpmail-smtp-service 465
     user-mail-address (password-store-get "streethawk/google/email")
     smtpmail-smtp-user (password-store-get "streethawk/google/username")
     notmuch-wash-wrap-lines-length 180
     notmuch-address-command 'internal
     )

    ;;(advice-add 'post-smtp-send :after 'async-smtpmail-send-it)

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
                     ((string-match "steven.joseph@iress.com.au" from) "iress")
                     ((string-match "steven@streethawk.com" from) "streethawk")
                     )))
              ;;(setq message-sendmail-extra-arguments (list '"-a" account))
              ))))

    ;;(add-hook 'message-send-mail-hook 'cg-feed-msmtp)

    (defun notmuch-search-toggle-tags (tags)
      "toggle tags for thread"
      (interactive)
      (if (cl-subsetp tags (notmuch-search-get-tags) :test 'string=)
          (notmuch-search-tag (mapcar (lambda (x) (concat "-" x)) tags))
        (notmuch-search-tag (mapcar (lambda (x) (concat "+" x)) tags)))
      (next-line)
      )
  (define-key notmuch-search-mode-map "y"
    (lambda ()
      "swipe misc email"
      (interactive)
      (notmuch-search-toggle-tags '("inbox"))))
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
  (define-key notmuch-search-mode-map "i"
    (lambda ()
      "toggle deleted tag for message"
      (interactive)
      (notmuch-search-toggle-tags '("important"))))

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
    (condition-case nil
        (browse-url-at-point)
      (error (notmuch-show-pipe-message nil "/home/steven/.bin/mutt_chrome.py"))
      )
    )
  (defun open-in-kmail ()
    (interactive)
    (message "open in kmail")
    (notmuch-show-pipe-message nil "/home/steven/.bin/stdinoutfile /tmp/steven/emailviewer")
    (shell-command "kmail --view 'file:///tmp/steven/emailviewer'  2>&1 > /dev/null & disown" nil nil)
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
  (define-key notmuch-show-mode-map "o" 'open-in-kmail)

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
              (format
               "gcalcli --nocolor --reminder '10m popup' --calendar %s import %s"
               cal
               temp_file
               )
              )
             )
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
  )

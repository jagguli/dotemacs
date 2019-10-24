(req-package notmuch
  :require (
            password-cache
            password-store
            dash
            addressbook-bookmark
            ;;auth-password-store
            )
  :config
  (setq
     notmuch-saved-searches
      (quote
       (
        (:name "all" :query "date:1M..now" :key "a")
        (:name "inbox" :query "tag:inbox not (tag:mailers) and date:30d..0s" :key "i")
        (:name "unread" :query "tag:unread and tag:inbox not (tag:mailers) and date:30d..0s" :key "u")
        (:name "sent/replied" :query "tag:sent tag:replied and date:30d..0s")
        (:name "drafts" :query "tag:draft" :key "d")
        (:name "important" :query "tag:important" :key "I")
        (:name "team" :query "date:1M..now and not tag:mailers and tag:team and tag:inbox" :key "t")
        (:name "pullrequests" :query "tag:pullrequests" :key "p")
        (:name "me" :query "tag:me" :key "m")
        (:name "stevenjoseph.in" :query "date:1M..now and to:steven@stevenjoseph.in" :key "j")
        (:name "melit" :query "date:1M..now and to:melit.stevenjoseph@gmail.com" :key "j")
        (:name "sentry" :query "tag:sentry")
        (:name "bitbucket" :query "tag:bitbucket")
        (:name "hawk" :query "tag:hawk")
        (:name "jira" :query "tag:jira")
        (:name "gitlab" :query "tag:gitlab")
        (:name "unread" :query "tag:unread")
        (:name "nomailers" :query "not tag:mailers")
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
     message-sendmail-envelope-from 'header
     notmuch-address-selection-function
      (lambda (prompt collection initial-input)
        (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history))

     smtpmail-debug-info t
     user-mail-address "steven@pointzi.com"

     ;;MSMTP config
     ;; This is needed to allow msmtp to do its magic:
    message-sendmail-f-is-evil 't

    ;;need to tell msmtp which account we're using
    message-sendmail-extra-arguments '("--read-envelope-from")
    ;; with Emacs 23.1, you have to set this explicitly (in MS Windows)
    ;; otherwise it tries to send through OS associated mail client
    message-send-mail-function 'message-send-mail-with-sendmail
    ;; we substitute sendmail with msmtp
    sendmail-program "/usr/sbin/msmtp"
    ;;need to tell msmtp which account we're using
    message-sendmail-extra-arguments '("-a" "pointzi")
    ;; you might want to set the following too
    mail-host-address "gmail.com"
    user-full-name "Steven Joseph"
    user-mail-address "steven@pointzi.com"
    ;; end MSMTP config

   gnus-alias-identity-alist
      '(("melit"
         nil ;; Does not refer to any other identity
         "Steven Joseph <steven@stevenjoseph.in>"
         nil ;; No organization header
         nil ;; No extra headers
         nil ;; No extra body text
         nil)
        ("pointzi"
         nil
         "Steven Joseph <steven@pointzi.com>"
         "Pointzi."
         nil
         nil
         "~/org/signatures/pointzi.txt"))     
     notmuch-wash-wrap-lines-length 180
     notmuch-address-command 'internal
     notmuch-identities '(
                          "steven@pointzi.com"
                          "steven@streethawk.com"
                          "steven@stevenjoseph.in"
                          "melit.stevenjoseph@gmail.com"
                          )
     ;;https://www.reddit.com/r/emacs/comments/9ep5o1/mu4e_stop_emails_setting_backgroundforeground/
     shr-color-visible-luminance-min 60
     shr-color-visible-distance-min 5
     shr-use-colors nil
     notmuch-search-line-faces
     (quote
      (("deleted" :foreground "grey" :background "brightblack")
       ("important" :foreground "red")
       ("unread" :foreground "green")
       ("today" :foreground "green" :background "color-232")
       ("flagged" :foreground "magenta")
       ("team" :foreground "brightgreen")
       ("draft" :foreground "brightblue")
       ("me" :foreground "white")
       ("INBOX" :foreground "color-243")
       )
      )
     )
  :init
  (progn
    (helm-mode)
    (add-hook
     'notmuch-message-mode-hook
     (lambda ()
       (flyspell-mode)))
    
    (defun notmuch-search-toggle-tags (tags)
      "toggle tags for thread"
      (interactive)
      (if (cl-subsetp tags (notmuch-search-get-tags) :test 'string=)
          (notmuch-search-tag (mapcar (lambda (x) (concat "-" x)) tags))
        (notmuch-search-tag (mapcar (lambda (x) (concat "+" x)) tags)))
      (next-line)
      )
    (evil-collection-define-key 'normal 'notmuch-show-mode-map
      "o" 'browse-url-at-point)
    (evil-collection-define-key '(normal visual insert) 'notmuch-search-mode-map
      "=" 'notmuch-refresh-this-buffer)
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
  (define-key notmuch-show-mode-map "O" 'open-in-kmail)

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
    (advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))

    )
  )

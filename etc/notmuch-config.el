(require 'notmuch)
(require 'notmuch-pick nil t)
(require 'notmuch-address)
(require 'password-cache)
(require 'keepassdb)

(notmuch-address-message-insinuate)

(defun message-send-mail-with-iress-sendmail ()
  (interactive)
  (setq message-sendmail-extra-arguments
        `("--passwordeval"
          ,(keepass-get-command "/iress/default" "password")))
  ;;(setq user-mail-address (format "%s@iress.com.au"
  ;;                                (keepass-get "/devices/iress")))
  (message-send-mail-with-sendmail))

(defun notmuch-config ()
  (interactive)
  (setq notmuch-wash-wrap-lines-length 70)
  (if (string-match "^SYDSJOSEPH.*" system-name )
      (progn 
	(setq notmuch-wash-original-regexp "^\\(From: .*\\|.* writes:\\)$")
	(setq notmuch-wash-citation-lines-prefix 0)
	(setq notmuch-identites '((keepass-get-command "/iress/default" "url")))

	(setq message-send-mail-function 'message-send-mail-with-iress-sendmail)
	(setq notmuch-address-command "~/bin/mutt_ldap.py"))
    (progn
      (setq message-send-mail-function 'message-send-mail-with-sendmail)
      (setq notmuch-address-command "~/bin/notmuch-goobook"))))

(notmuch-config)

(define-key notmuch-search-mode-map "d"
  (lambda ()
    "toggle deleted tag for thread"
    (interactive)
    (if (member "deleted" (notmuch-search-get-tags))
        (notmuch-search-tag "-deleted")
      (notmuch-search-tag '("+deleted" "-inbox" "-unread")))))

(define-key notmuch-show-mode-map "d"
  (lambda ()
    "toggle deleted tag for message"
    (interactive)
    (if (member "deleted" (notmuch-show-get-tags))
        (notmuch-show-tag "-deleted")
      (notmuch-show-tag '("+deleted" "-inbox" "-unread")))))


(define-key notmuch-search-mode-map "F"
  (lambda ()
    "toggle the flagged tag for thread"
    (interactive)
    (if (member "flagged" (notmuch-search-get-tags))
        (notmuch-search-tag "-flagged")
      (notmuch-search-tag "+flagged"))))

(define-key notmuch-show-mode-map "F"
  (lambda ()
    "toggle the flagged tag for message"
    (interactive)
    (if (member "flagged" (notmuch-show-get-tags))
        (notmuch-show-tag "-flagged")
      (notmuch-show-tag "+flagged"))))

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



(defun color-inbox-if-unread () (interactive)
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
  (notmuch-show-pipe-message nil "/home/steven/bin/mutt_chrome.py"))

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

(defun notmuch-show-accept-invite ()
  "accept ics invite"
  (interactive)
  (with-current-notmuch-show-message
   (let ((mm-handle (mm-dissect-buffer)))
     (notmuch-save-attachments
      mm-handle (> (notmuch-count-attachments mm-handle) 1))))
  (message "Done"))

(defun notmuch-accept-invite ()
  (notmuch-foreach-mime-part
   (lambda (p)
     (let ((disposition (mm-handle-disposition p)))
       (and (listp disposition)
            (or (equal (car disposition) "attachment")
                (and (equal (car disposition) "inline")
                     (assq 'filename disposition)))
            (or (not queryp)
                (y-or-n-p
                 (concat "Save '" (cdr (assq 'filename disposition)) "' ")))
            (mm-save-part p))))
   mm-handle))

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

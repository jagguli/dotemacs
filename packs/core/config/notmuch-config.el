(require 'notmuch)
(require 'notmuch-pick)
(require 'notmuch-address)
(if (string-match "^SYDSJOSEPH.*" system-name ) 
    (setq notmuch-address-command "~/bin/notmuch-lbdbq")
    (setq notmuch-address-command "~/bin/notmuch-goobook"))
(notmuch-address-message-insinuate)
;; with Emacs 23.1, you have to set this explicitly (in MS Windows)
;; otherwise it tries to send through OS associated mail client
(setq message-send-mail-function 'message-send-mail-with-sendmail)
;; we substitute sendmail with msmtp
(setq sendmail-program "/usr/bin/msmtp")
;;need to tell msmtp which account we're using
;;(setq message-sendmail-extra-arguments '("-a" "gmail"))
;; you might want to set the following too
;;(setq mail-host-address "iress.com.au")
;;(setq user-full-name "Steven Joseph")
;;(setq user-mail-address "example@exampl.com.au")

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
    (notmuch-show-mark-read)
    (notmuch-show-tag-all "-unread")
    (notmuch-show-collapse-all)))

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
  (notmuch-show-pipe-message t "/home/steven/bin/mutt_chrome.py"))

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

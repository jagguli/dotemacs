(require 'notmuch)
(require 'notmuch-pick)
(require 'notmuch-address)
(setq notmuch-address-command "~/bin/notmuch-goobook")
    (notmuch-address-message-insinuate)

;; with Emacs 23.1, you have to set this explicitly (in MS Windows)
;; otherwise it tries to send through OS associated mail client
(setq message-send-mail-function 'message-send-mail-with-sendmail)
;; we substitute sendmail with msmtp
(setq sendmail-program "/usr/bin/msmtp")
;;need to tell msmtp which account we're using
(setq message-sendmail-extra-arguments '("-a" "gmail"))
;; you might want to set the following too
;;(setq mail-host-address "stevenjoseph.in")
;;(setq user-full-name "Steven Joseph")
;;(setq user-mail-address "example@example.com")
;;(add-hook 'notmuch-search-hook 'notmuch-search-toggle-order)
;;(require 'vm-autoloads)
;;(setq user-full-name "Steven Joseph"
;;      mail-from-style 'angles
;;      user-mail-address "steven.joseph@iress.com.au"
;;      mail-default-reply-to user-mail-address)
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

(setq notmuch-search-line-faces
      '(("deleted" . (:foreground "red" :background "blue"))
        ("unread" . (:foreground "green"))
        ("flagged" . (:foreground "red" :background "lightgreen"))))

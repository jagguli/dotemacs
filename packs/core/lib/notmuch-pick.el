;; notmuch-pick.el --- displaying notmuch forests.
;;
;; Copyright © Carl Worth
;; Copyright © David Edmondson
;;
;; This file is part of Notmuch.
;;
;; Notmuch is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; Notmuch is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with Notmuch.  If not, see <http://www.gnu.org/licenses/>.
;;
;; Authors: David Edmondson <dme@dme.org>

(require 'mail-parse)

(require 'notmuch-lib)
(require 'notmuch-query)
(require 'notmuch-show)

(declare-function notmuch-call-notmuch-process "notmuch" (&rest args))
(declare-function notmuch-show "notmuch-show" (&rest args))
(declare-function notmuch-show-strip-re "notmuch-show" (subject))
(declare-function notmuch-show-clean-address "notmuch-show" (parsed-address))
(declare-function notmuch-show-spaces-n "notmuch-show" (n))

(defcustom notmuch-pick-author-width 50
  "Width of the author field."
  :group 'notmuch
  :type 'int)

(defvar notmuch-pick-previous-subject "")
(make-variable-buffer-local 'notmuch-pick-previous-subject)

(defvar notmuch-pick-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'notmuch-pick-goto-message)
    (define-key map [mouse-1] 'notmuch-pick-goto-message)
    (define-key map "q" '(lambda () (interactive) (kill-buffer (current-buffer))))
    map))
(fset 'notmuch-pick-mode-map notmuch-pick-mode-map)

(defun notmuch-pick-goto-message ()
  (interactive)
  (let ((id (save-excursion
	      (beginning-of-line)
	      (get-text-property (point) :notmuch-pick-message-id))))
    (when id
      (notmuch-show (concat "id:\"" id "\"")))))

(defun notmuch-pick-string-width (string width &optional right)
  (let ((s (format (format "%%%s%ds" (if right "" "-") width)
		   string)))
    (if (> (length s) width)
	(substring s 0 width)
      s)))

(defun notmuch-pick-insert-msg (msg depth tree-status)
  (let* ((headers (plist-get msg :headers))
	 (bare-subject (notmuch-show-strip-re (plist-get headers :Subject))))
    (insert (concat
	     (notmuch-pick-string-width
	      (plist-get msg :date_relative) 12 t)
	     "  "
	     (notmuch-pick-string-width
	      (concat (make-string depth ? )
		      (notmuch-show-clean-address (plist-get headers :From)))
	      notmuch-pick-author-width)
	     " "
	     (mapconcat #'identity (reverse tree-status) "")
	     (if (string= notmuch-pick-previous-subject bare-subject)
		 " ..."
	       bare-subject))
	    "\n")
    (save-excursion
      (beginning-of-line 0)
      (put-text-property (point) (1+ (point))
			 :notmuch-pick-message-id (plist-get msg :id)))
    (setq notmuch-pick-previous-subject bare-subject)))

(defun notmuch-pick-insert-tree (tree depth tree-status)
  "Insert the message tree TREE at depth DEPTH in the current thread."
  (let ((msg (car tree))
	(replies (cadr tree)))

    (let ((j (pop tree-status)))
      (cond
       ((eq (length tree-status) 0)
	(push " " tree-status))
       ((equal " " j)
	(push "╰" tree-status))
       ((equal "│" j)
	(push "├" tree-status))
       (t
	(push j tree-status)))

      (push (concat (if replies "┬" "─") "►") tree-status)
      (notmuch-pick-insert-msg msg depth tree-status)
      (pop tree-status)

      (pop tree-status)
      (push j tree-status))

    (notmuch-pick-insert-thread replies (1+ depth) tree-status)))

(defun notmuch-pick-insert-thread (thread depth tree-status)
  "Insert the thread THREAD at depth DEPTH in the current forest."
  (let ((n (length thread)))
    (push "│" tree-status)
    (loop for tree in thread
	  for count from 1 to n
	  if (eq count n)
	  do (progn
	       (pop tree-status)
	       (push " " tree-status))

	  do (notmuch-pick-insert-tree tree depth tree-status))))

(defun notmuch-pick-insert-forest (forest)
  (mapc '(lambda (thread)
	   (let (tree-status)
	     ;; Reset at the start of each main thread.
	     (setq notmuch-pick-previous-subject nil)
	     (notmuch-pick-insert-thread thread 0 tree-status)))
	forest))

(defun notmuch-pick (thread-id &optional query-context buffer-name)
  (interactive "sNotmuch pick: ")
  (let ((buffer (get-buffer-create (generate-new-buffer-name
				    (or buffer-name
					(concat "*notmuch-" thread-id "*")))))
	(inhibit-read-only t))
    (switch-to-buffer buffer)
;    (notmuch-show-mode)
    (erase-buffer)
    (goto-char (point-min))
    (save-excursion
      (let* ((basic-args (list thread-id))
	     (args (if query-context
		       (append (list "\'") basic-args (list "and (" query-context ")\'"))
		     (append (list "\'") basic-args (list "\'")))))
	(notmuch-pick-insert-forest (notmuch-query-get-threads args))
	;; If the query context reduced the results to nothing, run
	;; the basic query.
	(when (and (eq (buffer-size) 0)
		   query-context)
	  (notmuch-pick-insert-forest
	   (notmuch-query-get-threads basic-args)))))

    (setq truncate-lines t)
    (hl-line-mode 1)

    (use-local-map notmuch-pick-mode-map)))

;;

(provide 'notmuch-pick)

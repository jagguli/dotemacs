;; My miscellaneous functions

(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defalias 'my-kill-other-buffers 'kill-other-buffers)

(defun kill-all-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (buffer-list)))

(defun kill-other-file-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))

(defun edit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/emacs.el"))

(defun gettags (filename)
  (interactive)
  (shell-command-to-string
   (format "/home/steven/bin/tagquery.py %s" filename)))

;;======= command line  =======
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))

;; Usage: emacs -diff file1 file2

(defun xclip-insert ()
  (interactive)
  (insert (shell-command-to-string
      "xclip -o")))
;(setq org-agenda-include-diary t)
;(pop-to-buffer (get-buffer-create (generate-new-buffer-name "*scratch-org*")))
;(insert "Scratch buffer with org-mode.\n\n")
;(org-mode)

(defun filename-to-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (setq lineno  (what-line))
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (insert ":")
        (insert lineno)
        (shell-command-on-region (point-min) (point-max) "xsel -i"))
      (message filename))))
(defalias 'my-filename-to-clipboard 'filename-to-clipboard)

(defun gitblt-filename-to-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  ;;(setq lineno  (what-line))
  (let (
        (filename (file-relative-name (if (equal major-mode 'dired-mode)
                                          default-directory
                                        (buffer-file-name)) (repository-root)))
    (when filename
      (with-temp-buffer
        (insert (format 
                 "https://sydxplansvn.devel.iress.com.au/gerrit/plugins/gitblit/blob/?f=%s&r=%s.git&h=%s#L%s"
                 filename
                 (file-name-nondirectory filename)
                 (s-trim (vc-git--run-command-string (buffer-file-name) "symbolic-ref" "--short" "-q" "HEAD"))
                 (what-line)
                 ))
        (shell-command-on-region (point-min) (point-max) "xsel -i"))
      (message filename)))))


(setq locate-make-command-line
      (lambda (ss) (list locate-command "--database" "/home/steven/iress/locate.db" "--basename" "--regexp" ss)))
(defun check-debug (&optional buffer)
  (interactive)
  (if buffer (set-buffer buffer) (set-buffer (current-buffer)))
  (goto-char (point-min))
  (assert (= 0 (search-forward "sj_debug"))))

(add-hook 'vc-before-checkin-hook 
          #'(lambda ()
              (check-debug vc-parent-buffer)
              ))

(defun search-all-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

(global-set-key (kbd "M-s /") 'search-all-buffers)
(eval-after-load 'tramp '(setenv "SHELL" "/bin/sh"))

(defun guess-where-keybinding-is-defined (key)
  "try to guess where a key binding might be defined"
  (interactive (list (read-key-sequence "Describe key: ")))
  (let ((bindings (minor-mode-key-binding key))
        found)
    (while (and bindings (not found))
      (if (setq found (caar bindings))
          (find-function (cdar bindings)))
      (setq bindings (cdr bindings)))))

(defun reset-font ()
  (interactive)
  (global-font-lock-mode nil)
  (font-lock-fontify-buffer)
  (global-font-lock-mode t)
  (recenter-top-bottom))
(global-set-key (kbd "C-l") 'reset-font)

(defun browse-url-chrome (url &optional new-window)
  "Ask the Chromium WWW browser to load URL.
Default to the URL around or before point.  The strings in
variable `browse-url-chromium-arguments' are also passed to
Chromium."
  (interactive (browse-url-interactive-arg "URL: "))
  (message "opening chrome")
  (setq url (browse-url-encode-url url))
  (let* ((process-environment (browse-url-process-environment)))
    (apply 'start-process
	   (concat "conkeror " url) nil
	   "conkeror"
	   (append
	    browse-url-chromium-arguments
	    (list url)))))



(defadvice replace-highlight 
  (before outline-expand-replace 
          (match-beg match-end range-beg range-end
                     search-string regexp-flag delimited-flag
                     case-fold-search backward))

  (condition-case nil 
      (save-excursion
        (outline-back-to-heading)
        (show-subtree))
    (error nil))
)

(ad-activate 'replace-highlight)

(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files
    http://blog.plover.com/prog/revert-all.html"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (when (and (buffer-file-name buffer) 
                 (not (buffer-modified-p buffer)))
        (set-buffer buffer)
        (revert-buffer t t t))
      (setq list (cdr list))
      (setq buffer (car list))))
  (message "Refreshed open files"))

(defun my-insertion-filter (proc string)
  (when (buffer-live-p (process-buffer proc))
    (with-current-buffer (process-buffer proc)
      ;; Insert the text, advancing the process marker.
      (goto-char (process-mark proc))
      (insert string)
      (set-marker (process-mark proc) (point)))))

 (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;(add-to-list ‘comint-output-filter-functions ‘ansi-color-process-output)
(require 'shell)
(defun my-mongo-tail ()
  (interactive)
  (let ((output (get-buffer-create "*Mongotail Output*"))
        (default-directory (expand-file-name "~/iress/xplan/"))
        ;;(major-mode shell-mode)
        )
    ;;(set-buffer-major-mode output 
    (set-process-filter 
     (start-process 
      "mongotail" output "python" "scripts/mongotail.py" "-L" "DEBUG" "xplan.serverlog")
     'my-insertion-filter)
    (switch-to-buffer output)
    (ansi-term)
    (compilation-minor-mode 1)
))

(defun delete-terminal-tmux-rename (term)
              (shell-command "tmux rename-window zsh"))

(add-hook 'delete-terminal-functions 'delete-terminal-tmux-rename)

;; emacs doesn't actually save undo history with revert-buffer
;; see http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-04/msg00151.html
;; fix that.
;; http://stackoverflow.com/questions/4924389/is-there-a-way-to-retain-the-undo-list-in-emacs-after-reverting-a-buffer-from-fi
(defun revert-buffer-keep-history (&optional IGNORE-AUTO NOCONFIRM PRESERVE-MODES)
  (interactive)

  ;; tell Emacs the modtime is fine, so we can edit the buffer
  (clear-visited-file-modtime)

  ;; insert the current contents of the file on disk
  (widen)
  (delete-region (point-min) (point-max))
  (insert-file-contents (buffer-file-name))

  ;; mark the buffer as not modified
  (not-modified)
  (set-visited-file-modtime))

(setq revert-buffer-function 'revert-buffer-keep-history)

(defun load-config ()
    (interactive)
    (eval-buffer (helm-find-files-1 (expand-file-name "~/.emacs.d/etc/"))))

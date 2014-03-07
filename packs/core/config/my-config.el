(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

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

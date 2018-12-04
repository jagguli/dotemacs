;; Dired =============================================================================
(req-package dired+
  :require (evil dirtree)
  :config
  (progn 
    (setq ls-lisp-use-insert-directory-program nil)
    (setq-default dired-omit-files-p t) ; this is buffer-local
                                        ; variable
    (setq dired-listing-switches "-alh")
    (dired-omit-mode 1)
    ;;(require 'dired+-face-settings)
    (defun start-dired ()
      (interactive)
      (dired "."))
    (global-set-key (kbd "<escape>")      'keyboard-escape-quit)
    (define-key dired-mode-map (kbd "<ret>") 'diredp-find-file-reuse-dir-buffer)
    (toggle-diredp-find-file-reuse-dir 1)
    (diredp-toggle-find-file-reuse-dir 1)
    (add-to-list 'default-frame-alist '(background-mode . dark))
    (defun diredup ()
      (interactive)
      (find-alternate-file ".."))

    (define-key dired-mode-map (kbd "-") 'diredup)
    (add-hook 'dired-mode-hook 'setup-dired-keys)


    (defun toggle-dirtree ()
      (interactive)
      (if (get-buffer-window "*dirtree*")
          (delete-windows-on "*dirtree*")
        (dirtree (file-name-directory (buffer-file-name)) t)
        )
      )

    ;; Time-stamp: <2010-04-05 22:25:09 Monday by ahei>

    (defun beautiful-blue-face ((t (:foreground "cornflower blue"))))
    (defun dired+-face-settings ()
      "Face settings for `dired+'."

      (custom-set-faces '(diredp-display-msg
                          ((((type tty)) :foreground "blue")
                           (t :foreground "cornflower blue"))))
      (custom-set-faces '(diredp-date-time
                          ((((type tty)) :foreground "yellow")
                           (t :foreground "goldenrod1"))))
      (custom-set-faces '(diredp-dir-heading
                          ((((type tty)) :background "yellow" :foreground "blue")
                           (t :background "Pink" :foreground "DarkOrchid1"))))
      (setq diredp-ignored-file-name 'green-face)
      ;;(setq diredp-file-name 'darkred-face)
      (setq diredp-file-suffix 'magenta-face)
      (setq diredp-exec-priv 'darkred-face)
      (setq diredp-other-priv 'white-face)
      (setq diredp-no-priv 'darkmagenta-face)
      (setq diredp-write-priv 'darkcyan-face)
      (setq diredp-read-priv 'darkyellow-face)
      (setq diredp-link-priv 'lightblue-face)
      (setq diredp-symlink 'darkcyan-face)
      (setq diredp-rare-priv 'white-red-face)
      (setq diredp-dir-priv 'beautiful-blue-face)
      (setq diredp-compressed-file-suffix 'darkyellow-face))
    (global-set-key [f4] 'toggle-dirtree)
    (dired+-face-settings)
    )
  )

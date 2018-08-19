;; Dired =============================================================================
(req-package dired+
  :require (evil ls-lisp dirtree)
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

    (global-set-key [f4] 'toggle-dirtree)
    )
  )

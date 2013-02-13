;; Dired =============================================================================
(require 'dired+)
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)


(setq-default dired-omit-files-p t) ; this is buffer-local
                                ; variable

(setq dired-listing-switches "-alh")
(dired-omit-mode 1)
;;(require 'dired+-face-settings)
(defun start-dired ()
  (interactive)
  (dired "."))
(global-set-key [f4] 'start-dired)
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)
(define-key dired-mode-map [f3] 'buffer-menu)                              ;;
(define-key dired-mode-map (kbd "<ret>") 'diredp-find-file-reuse-dir-buffer)
(define-key dired-mode-map (kbd "-") 'dired-up-directory)
(toggle-diredp-find-file-reuse-dir 1)
(diredp-toggle-find-file-reuse-dir 1)
(add-to-list 'default-frame-alist '(background-mode . dark))

(add-hook 'dired-mode-hook
          '(lambda ()
(setq dired-listing-switches "-alh")
;;            (print "dired-mode-hook Called !!")
;;            (toggle-diredp-find-file-reuse-dir 1)
;;            (diredp-toggle-find-file-reuse-dir 1)
            ;;(define-key evil-normal-state-map (kbd "-") 'dired-up-directory)
;;(evil-mode 0)
            ))

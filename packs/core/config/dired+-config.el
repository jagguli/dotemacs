;; Dired =============================================================================
(require 'dired+)
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

;;(add-hook 'dired-mode-hook
;;          '(lambda ()
;;            (print "dired-mode-hook Called !!")
;;            (toggle-diredp-find-file-reuse-dir 1)
;;            (diredp-toggle-find-file-reuse-dir 1)
;;            ;;(define-key evil-normal-state-map (kbd "-") 'dired-up-directory)
;;            ;;(evil-mode 0)
;;            ))

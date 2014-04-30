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
(define-key dired-mode-map (kbd "<ret>") 'diredp-find-file-reuse-dir-buffer)
(toggle-diredp-find-file-reuse-dir 1)
(diredp-toggle-find-file-reuse-dir 1)
(add-to-list 'default-frame-alist '(background-mode . dark))


;;(add-hook 'dired-mode-hook
;;          '(lambda ()
;;             ;;(setq dired-listing-switches "-alh")
;;             (define-key dired-mode-map (kbd "^")
;;               (lambda () (interactive) (find-alternate-file "..")))
;;                                        ; was dired-up-directory
;;             ;;            (print "dired-mode-hook Called !!")
;;             ;;            (toggle-diredp-find-file-reuse-dir 1)
;;             ;;            (diredp-toggle-find-file-reuse-dir 1)
;;             ;;(define-key evil-normal-state-map (kbd "-") 'dired-up-directory)
;;             ;;(evil-mode 0)
;;             ))

(defun diredup ()
  (interactive)
  (find-alternate-file ".."))

(defun setup-dired-keys ()
  (define-key dired-mode-map (kbd "-") 'diredup)
  (define-key dired-mode-map [escape up] 'diredup)
  (define-key evil-normal-state-map "-" 'diredup)
  (define-key dired-mode-map [remap dired-up-directory] 'diredup))

(setup-dired-keys)

(add-hook 'dired-mode-hook 'setup-dired-keys)

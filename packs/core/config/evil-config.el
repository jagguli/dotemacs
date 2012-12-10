;; Evil =============================================================================
(require 'evil)
(require 'evil-search)
;;http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
(evil-mode 1)
(setq evil-default-state 'normal)
(setq evil-flash-delay 60)
(define-key global-map (kbd "<f3>") 'buffer-menu)
(define-key evil-insert-state-map (kbd "C-w") 'evil-window-map)
(define-key evil-insert-state-map (kbd "C-w <left>") 'evil-window-left)
(define-key evil-insert-state-map (kbd "C-w <right>") 'evil-window-right)
(define-key evil-insert-state-map (kbd "C-w <up>") 'evil-window-up)
(define-key evil-insert-state-map (kbd "C-w <down>") 'evil-window-down)
(define-key evil-normal-state-map (kbd "`") 'find-file)
;;(define-key global-map (kbd "`") 'find-file)
(evil-define-command "Ve" (function 
                            lambda() (split-window-horizontally)))
(defun vex ()
  (interactive)
  (split-window-horizontally))

(defun fileinfo ()
  (interactive)
  ;;(keyboard-quit)
  (message nil)
  (evil-show-file-info))

(global-set-key (kbd "C-g") 'fileinfo)
(global-set-key (kbd "C-c") 'quit)



;; Evil =============================================================================
(req-package evil
  :require (evil-org)
  :init
  (progn
    (setq x-select-enable-clipboard t
                x-select-enable-primary t)

    ;;http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
    (setq evil-default-state 'normal)

    (defun my-text-mode-hook ()
      (setq evil-symbol-word-search t))

    (evil-mode 1)
    (add-hook 'evil-local-mode-hook 'my-text-mode-hook)
    ;;(evil-set-initial-state 'notmuch-show-mode 'normal)
    (evil-set-initial-state 'jabber-chat-mode 'emacs)
    (evil-set-initial-state 'jabber-roster-mode 'emacs)
    (evil-set-initial-state 'direx:direx-mode 'emacs)
    (evil-set-initial-state 'mo-git-blame-mode 'emacs)
    (evil-set-initial-state 'svn-mode 'emacs)
    (evil-set-initial-state 'svn-status-mode 'emacs)
    (evil-set-initial-state 'newsticker-mode 'emacs)
    (evil-set-initial-state 'newsticker-treeview-mode 'emacs)
    (evil-set-initial-state 'notmuch-show-mode 'emacs)
    (evil-set-initial-state 'notmuch-tree-mode 'emacs)
    (evil-set-initial-state 'dirtree-mode 'emacs)
    (evil-set-initial-state 'egg-status 'emacs)
    (evil-set-initial-state 'egg-log 'emacs)
    (evil-set-initial-state 'egg-filehistory 'emacs)
    (evil-set-initial-state 'calendar-mode 'emacs)
    (evil-set-initial-state 'journal-mode 'emacs)
    (setq evil-flash-delay 60)
    ;;; esc quits


    (define-key evil-insert-state-map (kbd "C-w") 'evil-window-map)
    (define-key evil-insert-state-map (kbd "C-w <left>") 'evil-window-left)
    (define-key evil-insert-state-map (kbd "C-w <right>") 'evil-window-right)
    (define-key evil-insert-state-map (kbd "C-w <up>") 'evil-window-up)
    (define-key evil-insert-state-map (kbd "C-w <down>") 'evil-window-down)
    (define-key evil-normal-state-map (kbd "`") 'helm-find-files)
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
    ;;(global-set-key (kbd "C-c") 'quit)
    (define-key evil-normal-state-map [escape] 'fileinfo)
    ;(define-key minibuffer-local-map [escape] 'fileinfo)
    ;(define-key minibuffer-local-ns-map [escape] 'fileinfo)
    ;(define-key minibuffer-local-completion-map [escape] 'fileinfo)
    ;(define-key minibuffer-local-must-match-map [escape] 'fileinfo)
    ;(define-key minibuffer-local-isearch-map [escape] 'fileinfo)



    (setq evil-default-cursor t)

    ;;(iswitchb-mode 1)
    (setq iswitchb-buffer-ignore '("^\\*"))


    ;;(define-key evil-normal-state-map (kbd "C-^") 'iswitchb-buffer)


    (defun buffer-mode (buffer-or-string)
      "Returns the major mode associated with a buffer."
      (with-current-buffer buffer-or-string
        (format "%s" major-mode)))

    (defun other-buffer-ex ()
      (interactive)
      (switch-to-buffer (if (string-equal (buffer-mode (other-buffer)) "comint-mode")
             (next-buffer) (other-buffer))))  

    (evil-define-command evil-buffer-ex (buffer)
      "Switches to another buffer."
      :repeat nil
      (interactive "<b>")
      (if buffer
          (when (or (get-buffer buffer)
                    (y-or-n-p (format "No buffer with name \"%s\" exists. \
    Create new buffer? " buffer)))
            (switch-to-buffer buffer))
        (switch-to-buffer (other-buffer-ex))))

    (define-key evil-normal-state-map (kbd "C-^") 'evil-buffer-ex)
    ;; change mode-line color by evil state
    (lexical-let ((default-color (cons (face-background 'mode-line)
                                       (face-foreground 'mode-line))))
      (add-hook 'post-command-hook
                (lambda ()
                  (let ((color (cond ((minibufferp) default-color)
                                     ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                                     ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                     ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                     (t default-color))))
                    (set-face-background 'mode-line (car color))
                    (set-face-foreground 'mode-line (cdr color))))))
    )
  )

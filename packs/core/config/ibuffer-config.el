(require 'ibuffer)
(global-set-key "\C-xb" (lambda ()
                                   (interactive) (ibuffer)))
(global-set-key [(f3)] (lambda ()
                          (interactive)
			  ;;(split-window-right)
                          (ibuffer t)
                          (ibuffer-filter-disable)
                          ))
;;(define-key global-map (kbd "S-<f3>") 'ibuffer)
;;(define-key global-map (kbd "<f3>") '(lambda ()
;;                                       (interactive)
;;                                       (ibuffer t)))
;;(define-key ibuffer-mode-map (kbd "C-n") 'ibuffer-filter-by-name)
(define-key ibuffer-mode-map [(f3)] 'ibuffer-filter-by-name)
(menu-bar-mode 0)
(setq mode-line-format
          (list
           ;; value of `mode-name'
           "%m: "
           ;; value of current buffer name
           "buffer %b, "
           ;; value of current line number
           "line %l "
           "-- user: "
           ;; value of user
           (getenv "USER")))

(setq ibuffer-saved-filter-groups
      '(("home"
         ("Xplan Py" (filename . ".*iress/xplan.*py$"))
         ("Xplan html" (filename . ".*iress/xplan.*html$"))
         ("Xplan javascript" (filename . ".*iress/xplan.*js$"))
         ("python" (filename . ".*.py$"))
         ("javascript" (filename . ".*.js$"))
         ("html" (filename . ".*.html$"))
         ("mustache" (filename . ".*.mustache$"))
         ;;("Xplan Html" (or (mode . html-mode)
         ;;(mode . css-mode)))
         ("Hotfix" (filename . ".*iress/hotfix.*"))
         ("emacs-config" (or (filename . ".emacs.d")
                             (filename . "emacs-config")))
         ("Org" (or (mode . org-mode)
                    (filename . "OrgMode")))
         ("code" (filename . "code"))
         ("Subversion" (name . "\*svn"))
         ("Magit" (name . "\*magit"))
         ("ERC" (mode . erc-mode))
         ("Log Tail" (mode . comint-mode))
         ("Files" (filename . "^[:space:]*$"))
         ("Help" (or (name . "\*Help\*")
                     (name . "\*Apropos\*")
                          (name . "\*info\*"))))))
(setq ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-mode-hook
          '(lambda ()
                  (ibuffer-switch-to-saved-filter-groups "home")))

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000) (format "%7.3fk" (/ (buffer-size) 1000.0)))
   ((> (buffer-size) 1000000) (format "%7.3fM" (/ (buffer-size) 1000000.0)))
   (t (format "%8d" (buffer-size)))))

;;;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark read-only " "
              (name 50 50 :left :elide)
              " "
              (size-h 9 1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              filename-and-process)
	(filename-and-process)
))

;; Switching to ibuffer puts the cursor on the most recent buffer
(defadvice ibuffer (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name"
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
  (ad-activate 'ibuffer)

;;http://tuhdo.github.io/helm-intro.html
(req-package
   helm-mode
  :require
  (
   helm-cmd-t
   bookmark+
   helm-adaptive
   shackle
   helm-cscope
   helm-swoop
   helm-flycheck
   helm-chrome
   helm-projectile
   helm-package
   helm-fuzzy-find
   ag
   )
  :config
  (setq
   helm-split-window-in-side-p           nil ; open helm buffer inside current window, not occupy whole other window
   helm-move-to-line-cycle-in-source     nil ; move to end or beginning of source when reaching top or bottom of source.
   helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
   helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
   helm-ff-file-name-history-use-recentf t
   helm-autoresize-mode t
   helm-M-x-always-save-history t
   helm-always-two-windows t 
   helm-boring-buffer-regexp-list
   (quote
    ("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf" "\\*vc-"
     "\\*Complet" "\\*magit" "\\*cscope" "\\*epc"))
   helm-boring-file-regexp-list
   (quote
    ("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "~$" "\\.pyc$"))
   helm-buffers-fuzzy-matching t
   helm-M-x-fuzzy-match t
   helm-recentf-fuzzy-match t
   helm-mode-fuzzy-match t
   helm-buffers-fuzzy-matching t
   helm-imenu-fuzzy-match t
   helm-locate-fuzzy-match nil
   helm-semantic-fuzzy-match t
   helm-c-ack-version 2
   helm-ff-auto-update-initial-value nil
   helm-ff-file-name-history-use-recentf t
   helm-ff-ido-style-backspace t
   helm-ff-skip-boring-files t
   helm-ff-smart-completion t
   helm-ff-transformer-show-only-basename nil
   helm-findutils-skip-boring-files t
   helm-mode-handle-completion-in-region t
   helm-mode-reverse-history nil
   helm-quick-update t
   helm-reuse-last-window-split-state nil
   helm-match-plugin-mode t
   helm-adaptive-mode t
   helm-full-frame nil
   projectile-completion-system 'helm
   helm-buffer-max-length 30
   helm-ag-use-grep-ignore-list t
   helm-ag-use-agignore t
   helm-truncate-lines t

   helm-mini-default-sources
   (quote
    (
     helm-source-projectile-buffers-list
     helm-source-buffers-list
     helm-source-recentf
     helm-source-buffer-not-found
     ))
   helm-for-files-preferred-list
   (quote
    (
     ;;helm-source-projectile-recentf-list
     helm-source-recentf
     helm-source-projectile-files-list
     ;;helm-source-files-in-current-dir
     ;;helm-source-file-cache
     ;;helm-source-bookmarks
     ;;helm-source-locate
     )))

   ;;shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.5))
   ;;helm-split-window-default-side (quote left)
   ;;helm-adaptive-history-file
   ;;     (concat history-dir (format "helm-adaptive-history_%s" server-name))
  :init
  (progn
    ;;(add-user-lib "helm")
    (projectile-global-mode)
    (helm-mode)
    (helm-projectile-on)
    

    (global-set-key "\M-x" 'helm-M-x)
    (global-set-key "\C-xb" 'helm-bookmarks)
    (global-set-key "\C-x " 'helm-split-mini)
    (global-set-key "\C-c " 'helm-mini)
    (global-set-key "\C-xr" 'helm-recentf)
    ;;(define-key helm-command-map "b" 'helm-bookmarks)
    (global-set-key "\C-xt" 'helm-eproject-ag)
    (global-set-key "\C-xc" 'helm-resume)
    (global-set-key [(f5)] 'helm-etags-select)
    (global-set-key "\C-x/"  'helm-cmd-t)
    ;(global-set-key "\C-xv"  'helm-show-kill-ring)
    (global-set-key "\C-x\\"  'ag)
    (global-set-key "\M-so"  'helm-occur)
    ;;(defun sort-buffers ()
    ;;  "Put the buffer list in alphabetical order."
    ;;  (interactive)
    ;;  (dolist (buff (buffer-list-sorted)) (bury-buffer buff))
    ;;  (when (interactive-p) (list-buffers)))
    ;;
    ;;(defun buffer-list-sorted ()
    ;;  (sort (buffer-list)
    ;;        (function
    ;;         (lambda
    ;;           (a b) (string<
    ;;                  (downcase (buffer-name a))
    ;;                  (downcase (buffer-name b)))))))
    (defun helm-split-mini()
      (interactive)
      (let ((buffers (mapcar 'window-buffer (window-list))))
        (if (= 1 (length buffers))
            (split-window-sensibly)
          (other-window 1)
          ))
      (helm-mini))
    (eval-after-load "helm-ag"
      '(defun helm-ag--query ()
         (let* ((searched-word (helm-ag--searched-word))
                (marked-word (helm-ag--marked-input nil))
                (query (ag/read-from-minibuffer "Search string")))
           (when (string= query "")
             (error "Input is empty!!"))
           (setq helm-ag--last-query query)))
      )
    )
  )

(req-package helm-cmd-t
  :config (concat user-lib-dir "helm-cmd-t")
  :init
  (progn 
    (defun helm-cmd-t-ad-hoc-example ()
      "Choose file from test folder."
      (interactive)
      (helm :sources (list downloads-source docs-source)))
    )
  )

;;(req-package helm-recoll
;;             :load-path (concat user-lib-dir "helm-recoll")
;;             :config (progn
;;                       ;;(helm-recoll-create-source "docs" "~/.recoll/docs")
;;                       (helm-recoll-create-source "progs" "~/.recoll")
;;                       ;;(defun helmrecoll ()
;;                       ;;  (interactive)
;;                       ;;  (helm :sources '(helm-source-recoll-progs)))
;;                       ;;(global-set-key "\C-x?"  'helmrecoll)
;;                       )
;;             )

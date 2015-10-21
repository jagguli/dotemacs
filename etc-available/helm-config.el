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
     "\\*Complet" "\\*magit" "\\*tail" "\\*cscope" "\\*epc"))
   helm-boring-file-regexp-list
   (quote
    ("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "~$" "\\.pyc$"))
   helm-buffers-fuzzy-matching t
   helm-M-x-fuzzy-match t
   helm-recentf-fuzzy-match t
   helm-mode-fuzzy-match t
   helm-buffers-fuzzy-matching t
   helm-imenu-fuzzy-match t
   helm-locate-fuzzy-match t
   helm-semantic-fuzzy-match t
   helm-c-ack-version 2
   helm-ff-auto-update-initial-value nil
   helm-ff-file-name-history-use-recentf t
   helm-ff-ido-style-backspace t
   helm-ff-skip-boring-files t
   helm-ff-smart-completion t
   helm-ff-transformer-show-only-basename nil
   helm-findutils-skip-boring-files t
   helm-for-files-preferred-list
   (quote
    (helm-source-buffers-list
     helm-source-recentf helm-source-bookmarks
     helm-source-file-cache helm-source-files-in-current-dir helm-source-locate))
   helm-mode-handle-completion-in-region t
   helm-mode-reverse-history nil
   helm-quick-update t
   helm-reuse-last-window-split-state nil
   helm-match-plugin-mode t
   helm-adaptive-mode t
   helm-full-frame nil
   ;;shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.5))
   ;;helm-split-window-default-side (quote left)
   ;;helm-adaptive-history-file
   ;;     (concat history-dir (format "helm-adaptive-history_%s" server-name))
   )
  :init
  (progn
    (add-user-lib "helm")
    

    (defun helm-split-buffers-list ()
      (interactive)
      (let ((buffers (mapcar 'window-buffer (window-list))))
        (if (= 1 (length buffers))
            (split-window-sensibly)
          (other-window 1)
          ))
      (helm-buffers-list))
    (global-set-key "\M-x" 'helm-M-x)
    (global-set-key "\C-x\C-r" 'helm-for-files)
    (global-set-key "\C-xb" 'helm-mini)
    (global-set-key "\C-x " 'helm-bookmarks)
    (global-set-key [(f3)] 'helm-split-buffers-list)
    (define-key helm-command-map "b" 'helm-bookmarks)
    
    ;;(global-set-key [(control f3)] (lambda ()
    ;;                     (interactive) (ibuffer)))
    ;;(global-set-key [(f3)] (lambda ()
    ;;                          (interactive)
    ;;			  ;;(split-window-right)
    ;;                          (ibuffer t)
    ;;                          (ibuffer-filter-disable)
    ;;                          ))
    (defun helm-eproject-locate ()
      (interactive)
      (helm-locate-with-db (format "%s/locatedb"
                                   eproject-root))
      )

    (defun helm-eproject-ag ()
      (interactive)
      (let* ((helm-ag-default-directory (eproject-root))
             (header-name (format "Search at %s" helm-ag-default-directory)))
        (helm-attrset 'search-this-file nil helm-ag-source)
        (helm-attrset 'name header-name helm-ag-source)
        (helm :sources '(helm-ag-source) :buffer "*helm-ag*")))
    (global-set-key "\C-xt" 'helm-eproject-ag)
    (global-set-key [(f5)] 'helm-etags-select)
    (global-set-key "\C-x/"  'helm-cmd-t)
    (global-set-key "\C-x\\"  'ag)
    ;;(global-set-key "\C-x/"  'helm-eproject-locate)
    ;;(global-set-key [(shift f3)] (lambda ()
    ;;                               (Interactive) (ibuffer)))
    ;;(global-set-key [(f3)] (lambda ()
    ;;                          (interactive)
    ;;                          ;;(evil-window-vsplit)
    ;;                          (helm-mini)))
    ;;(add-hook 'ido-make-buffer-list-hook
    ;;          (lambda ()
    ;;            (ibuffer-sort-bufferlist ido-temp-list) ))
    ;;
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




    (helm-mode)
    (print "loaded helm-config")
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
(req-package helm-cmd-t
             :config (concat user-lib-dir "helm-cmd-t")
             :init (progn 

    (defun helm-cmd-t-ad-hoc-example ()
      "Choose file from test folder."
      (interactive)
      (helm :sources (list downloads-source docs-source)))
    )
             )

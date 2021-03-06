(live-add-pack-lib "helm")
(require 'helm-config)
;;(require 'helm-ag)
;;(require 'helm-command)
;;(require 'ibuffer)
(helm-mode 1)
(global-set-key "\M-x" 'helm-M-x)
(global-set-key "\C-x\C-r" 'helm-recentf)
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
(global-set-key "\C-x/"  'helm-eproject-locate)
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


(require 'helm)
(require 'helm-command)
;;(helm-mode 1)
(global-set-key "\M-x" 'helm-M-x)
(global-set-key "\C-x \C-r" 'helm-recentf)

;;(global-set-key [(shift f3)] (lambda ()
;;                               (Interactive) (ibuffer)))
(global-set-key [(f3)] (lambda ()
                          (interactive)
                          (helm-buffers-list)))

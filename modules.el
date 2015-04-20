(defconst user-lib-dir
  (file-name-as-directory (concat user-emacs-directory "lib")))

(defun load-user-config (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file (file-name-as-directory (concat user-emacs-directory "etc")))))

(defun add-user-lib (p)
  "Adds the path (specified relative to the the pack's lib dir)
  to the load-path"
  (add-to-list 'load-path (concat user-lib-dir p)))

(setq custom-theme-directory user-lib-dir)
(add-to-list 'load-path user-lib-dir)
;;(load-theme 'tango-2-steven t)


(require 'req-package)
(require 'buff-menu+)
(require 'fix-buffers-list)
(require 'repository-root)
(require 'popup-switcher)  
(require 'suggbind)  
(require 'sudo-ext)  
;;(require 'column-marker)
(require 'buffer-move)
(require 'ahg)
(require 'bind-key)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . mediawiki-mode))

(load-theme 'tango-2-steven t)
(load-file (concat user-emacs-directory "load-directory.el"))
(load-directory (concat user-emacs-directory "etc"))
;;(load-user-config "evil-config.el")
(add-user-lib "misc")
(add-user-lib "jedi-direx")
(add-user-lib "egg")
(add-user-lib "powerline")
(add-user-lib "powerline-evil")
(add-user-lib "toodledo")
(require 'org-toodledo)
(req-package-finish)
;;(load-user-config "my-config.el")
;;(load-user-config "modeline-config.el")
;;(load-user-config "helm-config.el")
;;(load-user-config "evil-clip-config.el")
;;(load-user-config "web-mode-config.el")
;;(load-user-config "psvn-config.el")
;;(load-user-config "grin-config.el")
;;;;(load-user-config "ack-and-half-config.el")
;;(load-user-config "javascript-config.el")
;;(load-user-config "minibuffer-config.el")
;;(load-user-config "python-config.el")
;;(load-user-config "ediff-config.el")
;;(load-user-config "xplan-config.el")
;;(load-user-config "cscope-config.el")
;;(load-user-config "flycheck-config.el")
;;;;(load-user-config "ibuffer-config.el")
;;(load-user-config "erlang-config.el")
;;(load-user-config "taskjuggler-config.el")
;;(load-user-config "twittering-config.el")
;;(load-user-config "jabber-config.el")
;;;;(load-user-config "calfw-config.el")
;;(load-user-config "tail-config.el")
;;(load-user-config "server-config.el")
;;(load-user-config "tmux-config.el")
;;(load-user-config "elisp-config.el")
;;(load-user-config "eproject-config.el")
;;(load-user-config "idutils-config.el")
;;(load-user-config "jedi-config.el")
;;;;(load-user-config "ecb-config.el")
;;(load-user-config "dired-config.el")
;;(load-user-config "dired+-config.el")
;;(load-user-config "other-buffer.el")
;;(load-user-config "guide-key-config.el")
;;;;(load-user-config "desktop-config.el")
;;(load-user-config "magit-config.el")
;;(load-user-config "orgmode-config.el")
;;(load-user-config "pushbullet-config.el")
;;(load-user-config "notmuch-config.el")
;;(load-user-config "mu4e-config.el")
;;(load-user-config "gnus-config.el")
;;(load-user-config "windows-config.el")
;;(load-user-config "egg-config.el")
;;(load-user-config "popwin-config.el")
;;;(load-user-config "wanderlust-config.el")
;;;;(add-user-lib "/usr/local/share/emacs/site-lisp/")
;;;;(load-user-config "elscreen-config.el")


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


(require 'buff-menu+)
(require 'fix-buffers-list)
(require 'repository-root)
(require 'org-journal)
(require 'popup-switcher)  
(require 'suggbind)  
(require 'sudo-ext)  
(require 'column-marker)
(load-theme 'tango-2-steven t)

;;(load-user-config "icicles-config.el")
;;(load-user-config "recent-files-config.el")
(add-user-lib "helm-cmd-t")

(load-user-config "my-config.el")
(load-user-config "helm-config.el")
(load-user-config "helm-recoll.el")
(load-user-config "evil-config.el")
(load-user-config "web-mode-config.el")
(load-user-config "psvn-config.el")
(load-user-config "grin-config.el")
(load-user-config "ack-and-half-config.el")
(load-user-config "javascript-config.el")
(load-user-config "minibuffer-config.el")
(load-user-config "python-config.el")
(load-user-config "ediff-config.el")
(load-user-config "xplan-config.el")
(load-user-config "cscope-config.el")
(load-user-config "flycheck-config.el")
;;(load-user-config "ibuffer-config.el")
(load-user-config "notmuch-config.el")
(load-user-config "erlang-config.el")
(load-user-config "taskjuggler-config.el")
(load-user-config "twittering-config.el")
;;(load-user-config "jabber-config.el")
(load-user-config "calfw-config.el")
(load-user-config "tail-config.el")
(load-user-config "server-config.el")
(load-user-config "tmux-config.el")
(load-user-config "elisp-config.el")
(load-user-config "eproject-config.el")
(load-user-config "modeline-config.el")
(load-user-config "idutils-config.el")
(load-user-config "jedi-config.el")
;;(load-user-config "ecb-config.el")
(load-user-config "dired-config.el")
(load-user-config "dired+-config.el")
(load-user-config "other-buffer.el")
(load-user-config "guide-key-config.el")
(load-user-config "desktop-config.el")
(load-user-config "magit-config.el")
(load-user-config "orgmode-config.el")
(add-user-lib "misc")
(add-user-lib "jedi-direx")
;;(add-user-lib "/usr/local/share/emacs/site-lisp/")
;;(load-user-config "elscreen-config.el")


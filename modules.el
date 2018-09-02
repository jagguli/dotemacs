(require 'package)
(setq package-enable-at-startup nil)
; this is a workaround for a bug in emacs' http fetching, see
; http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-12/msg00196.html
(setq url-http-attempt-keepalives t)

;; Bootstrap `req-package'
(unless (package-installed-p 'req-package)
  (package-refresh-contents)
  (package-install 'req-package))

(defun activated-packages ()
  (interactive)
  (message (format "%s" package-activated-list)))

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
;;(require 'sudo-ext)  
;;(require 'column-marker)
(require 'buffer-move)
(require 'ahg)
(require 'bind-key)
(require 'yaml-mode)
(show-paren-mode 1)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . mediawiki-mode))
(load-theme 'tango-2-steven t)
(load-file (concat user-emacs-directory "load-directory.el"))
;(add-user-lib "itail")
(add-user-lib "Pymacs")
(load-directory (concat user-emacs-directory "etc"))
(req-package-finish)


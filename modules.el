(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(setq package-enable-at-startup nil)
; this is a workaround for a bug in emacs' http fetching, see
; http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-12/msg00196.html
;;(setq url-http-attempt-keepalives t)

;; Bootstrap `req-package'
(unless (package-installed-p 'req-package)
  (package-refresh-contents)
  (package-install 'req-package))

(defun activated-packages ()
  (interactive)
  (message (format "%s" package-activated-list)))


(defconst user-lib-dir
  (file-name-as-directory (concat user-emacs-directory "modules.d")))
(defconst user-themes-dir
  (file-name-as-directory (concat user-emacs-directory "themes.d")))
(defconst user-config-dir
  (file-name-as-directory (concat user-emacs-directory "etc.d")))
(setq custom-theme-directory user-themes-dir)
(show-paren-mode 1)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . mediawiki-mode))
(load-theme 'tango-2-steven t)
(require 'load-dir)
(load-file (concat user-lib-dir "Pymacs/pymacs.el"))
(load-file (concat user-lib-dir "vline.el"))
(load-file (concat user-lib-dir "col-highlight.el"))
(load-file (concat user-lib-dir "hl-line+.el"))
;(load-file (concat user-lib-dir "notmuch-pick.el"))
;(add-to-list 'load-path (concat (user-lib-dir) "buffer-timer"))
;(add-to-list 'load-path (concat user-lib-dir "powerline"))
;(add-to-list 'load-path (concat user-lib-dir "powerline-evil"))
(require 'req-package)
(setq
 load-dir-recursive nil
 load-dirs `(
             ,user-lib-dir
             ,user-config-dir
            )
 )
(load-dirs)

(req-package-finish)

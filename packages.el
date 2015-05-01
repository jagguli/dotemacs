(require 'package)
(setq package-enable-at-startup nil)
; this is a workaround for a bug in emacs' http fetching, see
; http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-12/msg00196.html
(setq url-http-attempt-keepalives t)
(setq package-archives '(
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ;;("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ))

(package-initialize)

;; Bootstrap `req-package'
(unless (package-installed-p 'req-package)
  (package-refresh-contents)
  (package-install 'req-package))

;; Add in your own as you wish:
(defvar my-packages
  '(ag bookmark+ calfw calfw-gcal 
       ;color-file-completion color-moccur
       ;color-theme-actress color-theme-approximate
       ;color-theme-buffer-local
       ;color-theme-cobalt 
       ;color-theme-complexity color-theme-dg
       ;color-theme-dpaste color-theme-eclipse
       ;color-theme-emacs-revert-theme color-theme-github
       ;color-theme-gruber-darker color-theme-heroku
       ;color-theme-ir-black color-theme-library color-theme-molokai
       ;color-theme-monokai color-theme-railscasts
       ;color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow
       ;color-theme-solarized color-theme-tango color-theme-twilight
       ;color-theme-vim-insert-mode
       ;color-theme-wombat color-theme color-theme-x 
       column-marker
       diff-hl dired+ dired-details direx dsvn elscreen eproject
       erlang etags-select etags-table evil-leader evil-paredit evil
       findr flycheck-color-mode-line flycheck flymake-cursor goto-chg
       helm-ack helm-ag anything helm-dired-recent-dirs helm-git
       helm-git-grep helm-project-persist helm-projectile helm-recoll
       helm-themes helm helm-cmd-t itail jedi 
       ;;hideshowvis ipython pyflakes pymacs pysmell
       ;; repository-root  elisp-slime-nav
       ox-html5slide org-ehtml
       auto-complete epc ctable concurrent deferred jinja2-mode
       markdown-mode+ markdown-mode
       mo-git-blame multi-project multi-web-mode mustache
       mustache-mode nose notmuch-labeler notmuch org-journal
       outline-magic popup-switcher popup project-persist
       projectile pkg-info epl dash pylint 
       python scss-mode
       magit git-rebase-mode git-commit-mode ido-ubiquitous smex
       find-file-in-project paredit tango-2-theme twittering-mode
       undo-tree w3m web-mode xclip web-beautify unbound guide-key
       help-fns+ sudo-ext smart-mode-line crosshairs dirtree
       buffer-move jabber ahg egg password-store bind-key pushbullet
       shackle
       )
    "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
    (when (not (package-installed-p p))
         (package-install p)))

(defun activated-packages ()
  (interactive)
  (message (format "%s" package-activated-list)))


(require 'package)
 (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(ack-and-a-half ag bookmark+ calfw calfw-gcal color-file-completion color-moccur color-theme-active color-theme-actress color-theme-approximate color-theme-blackboard color-theme-buffer-local color-theme-cobalt color-theme-colorful-obsolescence color-theme-complexity color-theme-dawn-night color-theme-dg color-theme-dpaste color-theme-eclipse color-theme-emacs-revert-theme color-theme-github color-theme-gruber-darker color-theme-heroku color-theme-ir-black color-theme-library color-theme-molokai color-theme-monokai color-theme-railscasts color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow color-theme-solarized color-theme-tango color-theme-tangotango color-theme-twilight color-theme-vim-insert-mode color-theme-wombat+ color-theme-wombat color-theme color-theme-x column-marker diff-hl dired+ dired-details direx dsvn ecb elisp-slime-nav elscreen eproject erlang etags-select etags-table evil-paredit evil flycheck-color-mode-line flycheck flymake flymake-cursor grin hackernews hideshowvis icicles idle-highlight-mode ido-ubiquitous itail jedi auto-complete epc ctable concurrent deferred jinja2-mode magit magit-commit-training-wheels markdown-mode+ markdown-mode multi-project multi-web-mode mustache ht mustache-mode notmuch-labeler org-journal paredit popup-switcher popup powerline project-persist projectile dash pyflakes pylint pymacs pysmell python-magic python-mode repository-root s scss-mode smex tango-2-theme twittering-mode undo-tree w3m web-mode xclip)
    "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
    (when (not (package-installed-p p))
          (package-install p)))

(defun activated-packages ()
  (interactive)
  (message (format "%s" package-activated-list)))

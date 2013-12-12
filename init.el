(require 'package)
 (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(outline-magic ack-and-a-half ag bookmark+ calfw calfw-gcal color-file-completion color-moccur color-theme-active color-theme-actress color-theme-approximate color-theme-blackboard color-theme-buffer-local color-theme-cobalt color-theme-colorful-obsolescence color-theme-complexity color-theme-dawn-night color-theme-dg color-theme-dpaste color-theme-eclipse color-theme-emacs-revert-theme color-theme-github color-theme-gruber-darker color-theme-heroku color-theme-ir-black color-theme-library color-theme-molokai color-theme-monokai color-theme-railscasts color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow color-theme-solarized color-theme-tango color-theme-tangotango color-theme-twilight color-theme-vim-insert-mode color-theme-wombat+ color-theme-wombat color-theme color-theme-x column-marker diff-hl dired+ dired-details direx dsvn ecb elscreen eproject erlang etags-select etags-table evil-leader evil-paredit evil findr flycheck-color-mode-line flycheck flymake-cursor grin hackernews helm-ack helm-ag helm-anything anything helm-c-moccur helm-dired-recent-dirs helm-git helm-git-grep helm-ls-git helm-mercurial-queue helm-project-persist helm-projectile helm-recoll helm-themes helm hideshowvis icicles ipython itail jedi auto-complete epc ctable concurrent deferred jinja2-mode magit-commit-training-wheels markdown-mode+ markdown-mode multi-project multi-web-mode mustache ht mustache-mode nose notmuch-labeler org-journal popup-switcher popup powerline project-persist projectile pkg-info epl dash pyflakes pylint pymacs pysmell python python-magic python-mode realgud repository-root s scss-mode starter-kit-bindings starter-kit-lisp elisp-slime-nav starter-kit magit ido-ubiquitous smex find-file-in-project idle-highlight-mode paredit sunrise-x-tree sunrise-commander tango-2-theme twittering-mode undo-tree w3m web-mode xclip)
    "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
    (when (not (package-installed-p p))
         (package-install p)))

(defun activated-packages ()
  (interactive)
  (message (format "%s" package-activated-list)))

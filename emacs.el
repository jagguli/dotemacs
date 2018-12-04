(defun shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (recentf-save-list)
  (kill-emacs))

(defun reload-emacs-config ()
  "reload emacs config"
  (interactive)
  (load-file "~/.emacs.d/init.el")
)
(defvar server-name "" "current server name")
(defun start-server (name)
  "start an emacs server"
  (interactive)
  (setq server-name name)
  (setq server-use-tcp t)
  (server-start)
  (setq history-dir (expand-file-name "~/.emacs.d/history.d/"))
  (setq savehist-additional-variables    ;; also save...
        '(search-ring regexp-search-ring)    ;; ... my search entries
        savehist-file (concat history-dir (format "history_%s" server-name)))
  ;;(require recentf)
  ;;(recentf-mode 1)
  (setq recentf-initialize-file-name-history t)
  (setq recentf-save-file (concat history-dir (format "recentf_%s" server-name)))
  (recentf-load-list)
  (require 'org-protocol)
  )

(defun shell-command-maybe (exe &optional paramstr)
  "run executable EXE with PARAMSTR, or warn if EXE's not available; eg. "
  " (djcb-shell-command-maybe \"ls\" \"-l -a\")"
  (if (executable-find exe)
    (shell-command-to-string (concat exe " " paramstr))
    (message (concat "'" exe "' not found found; please install"))))

(setq-default
 indent-tabs-mode nil
 c-basic-offset 4
 )
(setq
 req-package-log-level "debug"
 initial-scratch-message (format "     MM\"\"\"\"\"\"\"\"`M
     MM  mmmmmmmM
     M`      MMMM 88d8b.d8b. .d8888b. .d8888b. .d8888b.
     MM  MMMMMMMM 88''88'`88 88'  `88 88'  `\"\" Y8ooooo.
     MM  MMMMMMMM 88  88  88 88.  .88 88.  ...       88
     MM        .M dP  dP  dP `88888P8 '88888P' '88888P'
     MMMMMMMMMMMM

         M\"\"MMMMMMMM M\"\"M M\"\"MMMMM\"\"M MM\"\"\"\"\"\"\"\"`M
         M  MMMMMMMM M  M M  MMMMM  M MM  mmmmmmmM
         M  MMMMMMMM M  M M  MMMMP  M M`      MMMM
         M  MMMMMMMM M  M M  MMMM' .M MM  MMMMMMMM
         M  MMMMMMMM M  M M  MMP' .MM MM  MMMMMMMM
         M         M M  M M     .dMMM MM        .M
         MMMMMMMMMMM MMMM MMMMMMMMMMM MMMMMMMMMMMM

           http://github.com/jagguli/dotemacs
 
%s

"  (shell-command-maybe "fortune") )
 initial-buffer-choice nil
 inhibit-startup-screen t
 font-lock-maximum-decoration t
 stack-trace-on-error t
 inhibit-splash-screen t
 inhibit-startup-echo-area-message t
 inhibit-startup-message t
 paredit-mode 0
 uniqueify-buffer-name-style 'reverse
 c-default-style "linux"
 c-basic-offset 4
 x-select-enable-clipboard t
 inhibit-splash-screen t
 ido-use-filename-at-point nil
 plantuml-jar-path "/opt/plantuml/plantuml.jar"
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/tmp/backups"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t       ; use versioned backups
 frame-title-format "%b"
 use-package-always-ensure t
 )

(goto-address-mode)
(global-font-lock-mode t)
(add-to-list 'auto-mode-alist '("\\.*rc$" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(defalias 'yes-or-no-p 'y-or-n-p)
(if (fboundp 'toggle-scroll-bar)
    (toggle-scroll-bar -1))

;;(setenv "SSH_AUTH_SOCK" (concat (getenv "HOME") "/.ssh-auth-sock"))
(setenv "XDG_CURRENT_DESKTOP" "LXDE")
(savehist-mode t)         
(menu-bar-mode -1)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'scroll-left 'disabled nil)
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))

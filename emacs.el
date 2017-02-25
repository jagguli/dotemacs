;; Settings ===============
;; (setq initial-scratch-message (format ";;     MM\"\"\"\"\"\"\"\"`M
;; ;;     MM  mmmmmmmM
;; ;;     M`      MMMM 88d8b.d8b. .d8888b. .d8888b. .d8888b.
;; ;;     MM  MMMMMMMM 88''88'`88 88'  `88 88'  `\"\" Y8ooooo.
;; ;;     MM  MMMMMMMM 88  88  88 88.  .88 88.  ...       88
;; ;;     MM        .M dP  dP  dP `88888P8 '88888P' '88888P'
;; ;;     MMMMMMMMMMMM
;; ;;
;; ;;         M\"\"MMMMMMMM M\"\"M M\"\"MMMMM\"\"M MM\"\"\"\"\"\"\"\"`M
;; ;;         M  MMMMMMMM M  M M  MMMMM  M MM  mmmmmmmM
;; ;;         M  MMMMMMMM M  M M  MMMMP  M M`      MMMM
;; ;;         M  MMMMMMMM M  M M  MMMM' .M MM  MMMMMMMM
;; ;;         M  MMMMMMMM M  M M  MMP' .MM MM  MMMMMMMM
;; ;;         M         M M  M M     .dMMM MM        .M
;; ;;         MMMMMMMMMMM MMMM MMMMMMMMMMM MMMMMMMMMMMM
;; ;;
;; ;;           http://github.com/jagguli/dotemacs
;; ;; 
;; %s
;; 
;; "  (shell-command-to-string "fortune") ))

(setq initial-scratch-message nil)
(setq initial-buffer-choice nil)
(setq inhibit-startup-screen t)
;;(setq after-make-frame-functions nil)

(goto-address-mode)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq-default indent-tabs-mode nil)
(add-to-list 'auto-mode-alist '("\\.*rc$" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(defalias 'yes-or-no-p 'y-or-n-p)
(setq stack-trace-on-error t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq paredit-mode 0)
(setq uniqueify-buffer-name-style 'reverse)
(setq-default c-basic-offset 4)
(setq c-default-style "linux"
                c-basic-offset 4)
(setq x-select-enable-clipboard t)
(savehist-mode 1)
(setq inhibit-splash-screen t)
(menu-bar-mode -1)
(setq ido-use-filename-at-point nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
;;(setq debug-on-error t)

(savehist-mode t)         
  
;;(setenv "SSH_AUTH_SOCK" (concat (getenv "HOME") "/.ssh-auth-sock"))

(setq plantuml-jar-path "/opt/plantuml/plantuml.jar")

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/tmp/backups"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

(setq frame-title-format "%b")
(setq sauron-dbus-cookie t)
(if (fboundp 'toggle-scroll-bar)
    (toggle-scroll-bar -1))

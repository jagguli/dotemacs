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


(defun browse-url-chrome (url &optional new-window)
  "Ask the Chromium WWW browser to load URL.
Default to the URL around or before point.  The strings in
variable `browse-url-chromium-arguments' are also passed to
Chromium."
  (interactive (browse-url-interactive-arg "URL: "))
  (message "opening chrome")
  (setq url (browse-url-encode-url url))
  (let* ((process-environment (browse-url-process-environment)))
    (apply 'start-process
	   (concat "google-chrome " url) nil
	   "google-chrome"
	   (append
	    browse-url-chromium-arguments
	    (list url)))))

(defun reset-font ()
  (interactive)
  (global-font-lock-mode nil)
  (font-lock-fontify-buffer)
  (global-font-lock-mode t)
  (recenter-top-bottom))
(global-set-key (kbd "C-l") 'reset-font)


(defun guess-where-keybinding-is-defined (key)
  "try to guess where a key binding might be defined"
  (interactive (list (read-key-sequence "Describe key: ")))
  (let ((bindings (minor-mode-key-binding key))
        found)
    (while (and bindings (not found))
      (if (setq found (caar bindings))
          (find-function (cdar bindings)))
      (setq bindings (cdr bindings)))))

  

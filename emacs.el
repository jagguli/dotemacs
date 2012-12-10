(load-file "~/.emacs.d/init.el")
(load-file "~/.emacs.d/packs.el")

; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(defun reload-emacs-config ()
  "reload emacs config"
  (interactive)
  (load-file "~/.emacs"))

(defun edit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/emacs.el"))

;;======= Code folding =======
(defun jao-toggle-selective-display ()
  (interactive)
  (set-selective-display (if selective-display nil 1)))

;; Settings ===============

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ack-and-a-half-prompt-for-directory t)
 '(compilation-disable-input t)
 '(custom-enabled-themes (quote (tango-2-steven)))
 '(custom-safe-themes (quote ("13b2915043d7e7627e1273d98eb95ebc5b3cc09ef4197afb2e1ede78fe6e0972" "1057947e1144d06a9fc8e97b6a72b72cf533a4cfe1247c4af047dc9221e9b102" "3800c684fc72cd982e3366a7c92bb4f3975afb9405371c7cfcbeb0bee45ddd18" "7c66e61cada84d119feb99a90d30da44fddc60f386fca041c01de74ebdd934c2" "f41ff26357e8ad4d740901057c0e2caa68b21ecfc639cbc865fdd8a1cb7563a9" "1797bbff3860a9eca27b92017b96a0df151ddf2eb5f73e22e37eb59f0892115e" "21d9280256d9d3cf79cbcf62c3e7f3f243209e6251b215aede5026e0c5ad853f" default)))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ("/home/steven/iress/xplan/")))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(evil-search-module (quote evil-search))
 '(grep-command "ack --with-filename --nogroup --all")
 '(lazy-highlight-cleanup nil)
 '(lazy-highlight-initial-delay 0)
 '(lazy-highlight-max-at-a-time nil)
 '(paredit-mode nil t)
 '(recentf-mode t)
 '(repository-root-matchers (quote (repository-root-matcher/git repository-root-matcher/svn))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diredp-date-time ((((type tty)) :foreground "yellow") (t :foreground "goldenrod1")))
 '(diredp-dir-heading ((((type tty)) :background "yellow" :foreground "blue") (t :background "Pink" :foreground "DarkOrchid1")))
 '(diredp-display-msg ((((type tty)) :foreground "blue") (t :foreground "cornflower blue")))
 '(flymake-errline ((t (:background "color-53"))))
 '(flymake-warnline ((t (:background "color-58")))))

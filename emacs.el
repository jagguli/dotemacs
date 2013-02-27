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

(load-file "~/.emacs.d/init.el")
(load-file "~/.emacs.d/packs.el")


(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(add-to-list 'auto-mode-alist '("\\.*rc$" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(require 'find-file-in-project)
;;(setq ffip-project-file ".emacs-project" )
;;(setq ffip-project-root "~/iress/xplan/" )
(setq ffip-limit 9000000 )
(setq ffip-find-options "-not -regex \".*tranlog.*\" -not -regex \".*min\.js.*\" -not -regex \".*\.class$\"" )
(add-to-list 'ffip-patterns "*.java")
(add-to-list 'ffip-patterns "*.idl")

(global-set-key (kbd "C-x /") 'find-file-in-project)

;;======= command line  =======
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))

;; Usage: emacs -diff file1 file2

(defun xclip-insert ()
  (interactive)
  (insert (shell-command-to-string
      "xclip -o")))
(setq inhibit-splash-screen t)
;(setq org-agenda-include-diary t)
;(pop-to-buffer (get-buffer-create (generate-new-buffer-name "*scratch-org*")))
;(insert "Scratch buffer with org-mode.\n\n")
;(org-mode)

(defun my-put-file-name-on-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(setq locate-make-command-line
      (lambda (ss) (list locate-command "--database" "/home/steven/iress/locate.db" "--basename" "--regexp" ss)))
(defun check-debug (&optional buffer)
  (interactive)
  (if buffer (set-buffer buffer) (set-buffer (current-buffer)))
  (goto-char (point-min))
  (assert (= 0 (search-forward "sj_debug"))))

(add-hook 'vc-before-checkin-hook 
          #'(lambda ()
              (check-debug vc-parent-buffer)
              ))
;;======= Code folding =======
(defun jao-toggle-selective-display ()
  (interactive)
  (set-selective-display (if selective-display nil 1)))

(defun search-all-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

(global-set-key (kbd "M-s /") 'search-all-buffers)
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . mustache-mode))
(eval-after-load 'tramp '(setenv "SHELL" "/bin/sh"))

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
(savehist-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ack-and-a-half-prompt-for-directory t)
 '(auto-revert-interval 0.5)
 '(browse-url-browser-function (quote browse-url-chromium))
 '(compilation-disable-input t)
 '(custom-enabled-themes (quote (tango-2-steven)))
 '(custom-safe-themes (quote ("13b2915043d7e7627e1273d98eb95ebc5b3cc09ef4197afb2e1ede78fe6e0972" "1057947e1144d06a9fc8e97b6a72b72cf533a4cfe1247c4af047dc9221e9b102" "3800c684fc72cd982e3366a7c92bb4f3975afb9405371c7cfcbeb0bee45ddd18" "7c66e61cada84d119feb99a90d30da44fddc60f386fca041c01de74ebdd934c2" "f41ff26357e8ad4d740901057c0e2caa68b21ecfc639cbc865fdd8a1cb7563a9" "1797bbff3860a9eca27b92017b96a0df151ddf2eb5f73e22e37eb59f0892115e" "21d9280256d9d3cf79cbcf62c3e7f3f243209e6251b215aede5026e0c5ad853f" default)))
 '(dired-omit-files "^\\.[^.]+.*$")
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ("/home/steven/iress/xplan/")))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(evil-fold-level 1)
 '(evil-search-module (quote evil-search))
 '(grep-command "ack --with-filename --nogroup --all")
 '(jabber-auto-reconnect t)
 '(jabber-roster-line-format "  %c %-25n %u %-8s  %S")
 '(lazy-highlight-cleanup nil)
 '(lazy-highlight-initial-delay 0)
 '(lazy-highlight-max-at-a-time nil)
 '(ls-lisp-verbosity (quote nil))
 '(newsticker-url-list (quote (("FastCompany" "http://www.fastcompany.com/rss.xml" nil nil nil) ("TheNextWeb" "http://feeds2.feedburner.com/thenextweb" nil nil nil) ("BoingBoing" "http://feeds.boingboing.net/boingboing/iBag" nil nil nil) ("TechRepublic" "http://www.techrepublic.com/search?t=1&o=1&mode=rss" nil nil nil) ("TechCrunch" "http://feeds.feedburner.com/TechCrunch/" nil nil nil))))
 '(notmuch-saved-searches (quote (("unread" . "tag:unread") ("sent/replied" . "tag:sent tag:replied and date:30d..0s") ("inbox" . "(tag:INBOX or  tag:inbox) and not tag:osc") ("osc" . "tag:osc") ("osc_note" . "tag:osc  and \"a NOTE has been added\""))))
 '(notmuch-search-hook (quote (notmuch-hl-line-mode)))
 '(notmuch-search-line-faces (quote (("deleted" :foreground "red" :background "blue") ("unread" :foreground "green") ("flagged" :foreground "magenta") ("me" :weight bold :foreground "white") ("INBOX" :foreground "color-243"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(notmuch-show-hook (quote (notmuch-show-turn-on-visual-line-mode)))
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-show-indent-multipart t)
 '(org-agenda-files (quote ("~/Dropbox/OrgMode/work.org" "~/Dropbox/OrgMode/startup.org" "~/Dropbox/OrgMode/zen.org")))
 '(org-directory "~/Dropbox/OrgMode")
 '(org-mobile-directory "~/Dropbox/MobileOrg")
 '(org-mobile-inbox-for-pull "~/Dropbox/MobileOrg/mobileorg.org")
 '(org-todo-keywords (quote ((sequence "TODO" "DONE" "CANCELED"))))
 '(paredit-mode nil t)
 '(recentf-mode t)
 '(repository-root-matchers (quote (repository-root-matcher/git repository-root-matcher/svn)))
 '(scss-compile-at-save nil)
 '(send-mail-function (quote mailclient-send-it))
 '(split-width-threshold 105)
 '(split-window-keep-point nil)
 '(xclip-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(column-marker-1 ((t (:background "color-53"))))
 '(cursor ((t (:background "light slate blue" :foreground "#888888"))))
 '(diredp-date-time ((((type tty)) :foreground "yellow") (t :foreground "goldenrod1")) t)
 '(diredp-dir-heading ((((type tty)) :background "yellow" :foreground "blue") (t :background "Pink" :foreground "DarkOrchid1")) t)
 '(diredp-dir-priv ((t (:background "color-16" :foreground "color-21"))) t)
 '(diredp-display-msg ((((type tty)) :foreground "blue") (t :foreground "cornflower blue")) t)
 '(diredp-file-name ((t nil)) t)
 '(diredp-file-suffix ((t nil)) t)
 '(flymake-errline ((t (:background "color-124"))))
 '(flymake-warnline ((t (:background "color-161"))))
 '(match ((t (:background "color-22"))))
 '(notmuch-tag-face ((t (:foreground "color-19"))))
 '(vertical-border ((t (:inherit mode-line-inactive :background "grey" :foreground "grey" :weight thin :width condensed)))))

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

(goto-address-mode)
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

(defun gettags (filename)
  (interactive)
  (shell-command-to-string
   (format "/home/steven/bin/tagquery.py %s" filename)))
;;(setq speedbar-fetch-etags-command "/home/steven/bin/tagquery.py")
;;            speedbar-fetch-etags-arguments '(""))
(load "speedbar")
(setq speedbar-fetch-etags-parse-list
      (cons '("\\.py\\'" . speedbar-parse-c-or-c++tag)
                        speedbar-fetch-etags-parse-list))
(setq speedbar-fetch-etags-arguments nil)
(setq speedbar-fetch-etags-command "tagquery.py")
(setq speedbar-supported-extension-expressions (quote (".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?" ".tex\\(i\\(nfo\\)?\\)?" ".el" ".emacs" ".l" ".lsp" ".p" ".java" ".js" ".f\\(90\\|77\\|or\\)?" ".py")))
(setq speedbar-use-imenu-flag nil)
(setq speedbar-verbosity-level 2)
(setq speedbar-dynamic-tags-function-list
      (delete (first speedbar-dynamic-tags-function-list)
              speedbar-dynamic-tags-function-list))
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
  (setq lineno  (what-line))
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (insert " ")
        (insert lineno)
        (insert "\n\n")
        (shell-command-on-region (point-min) (point-max) "xclip -i"))
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
  (set-selective-display (if selective-display nil 2)))

(defun search-all-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

(global-set-key (kbd "M-s /") 'search-all-buffers)
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

;;;###autoload
(defun browse-url-chrome (url &optional new-window)
  "Ask the Chromium WWW browser to load URL.
Default to the URL around or before point.  The strings in
variable `browse-url-chromium-arguments' are also passed to
Chromium."
  (interactive (browse-url-interactive-arg "URL: "))
  (setq url (browse-url-encode-url url))
  (let* ((process-environment (browse-url-process-environment)))
    (apply 'start-process
	   (concat "google-chrome " url) nil
	   "google-chrome"
	   (append
	    browse-url-chromium-arguments
	    (list url)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ack-and-a-half-prompt-for-directory t)
 '(ansi-color-faces-vector [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector (vector "#839496" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#002b36"))
 '(auth-source-protocols (quote ((imap "imap" "imaps" "143" "993") (pop3 "pop3" "pop" "pop3s" "110" "995") (ssh "ssh" "22") (sftp "sftp" "115") (smtp "smtp" "25") (jabber "jabber-client" "5222"))))
 '(auth-sources (quote ("~/.authinfo")))
 '(auto-revert-interval 0.5)
 '(background-color nil)
 '(background-mode dark)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(browse-url-browser-function (quote browse-url-chromium))
 '(compilation-disable-input t)
 '(cursor-color nil)
 '(custom-enabled-themes (quote (tango-2-steven)))
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "e9a1226ffed627ec58294d77c62aa9561ec5f42309a1f7a2423c6227e34e3581" "13b2915043d7e7627e1273d98eb95ebc5b3cc09ef4197afb2e1ede78fe6e0972" "1057947e1144d06a9fc8e97b6a72b72cf533a4cfe1247c4af047dc9221e9b102" "3800c684fc72cd982e3366a7c92bb4f3975afb9405371c7cfcbeb0bee45ddd18" "7c66e61cada84d119feb99a90d30da44fddc60f386fca041c01de74ebdd934c2" "f41ff26357e8ad4d740901057c0e2caa68b21ecfc639cbc865fdd8a1cb7563a9" "1797bbff3860a9eca27b92017b96a0df151ddf2eb5f73e22e37eb59f0892115e" "21d9280256d9d3cf79cbcf62c3e7f3f243209e6251b215aede5026e0c5ad853f" default)))
 '(dired-omit-files "^\\.[^.]+.*$")
 '(ecb-activation-selects-ecb-frame-if-already-active t)
 '(ecb-options-version "2.40")
 '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote ("/home/steven/iress/xplan/" "/home/steven/iress")))
 '(ecb-tree-indent 2)
 '(ecb-vc-enable-support nil)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(evil-fold-level 1)
 '(evil-search-module (quote evil-search))
 '(fci-rule-color "#073642")
 '(foreground-color nil)
 '(grep-command "ack --with-filename --nogroup --all")
 '(grep-highlight-matches (quote auto))
 '(gud-pdb-command-name "python -d")
 '(helm-for-files-preferred-list (quote (helm-source-buffers-list helm-source-recentf helm-source-bookmarks helm-source-file-cache helm-source-files-in-current-dir helm-source-locate helm-source-id-utils)))
 '(helm-match-plugin-mode t nil (helm-match-plugin))
 '(itail-fancy-mode-line t)
 '(itail-highlight-list (quote (("Error" . hi-red-b) ("GET\\|POST\\|DELETE\\|PUT" . hi-green-b) ("[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}" . font-lock-string-face) ("File \\\".*\\\"" . hi-red-b) ("^Traceback.*$" . hi-red-b))))
 '(jabber-alert-message-hooks (quote (jabber-message-display jabber-message-echo jabber-message-wave jabber-message-libnotify)))
 '(jabber-auto-reconnect t)
 '(jabber-history-enable-rotation t)
 '(jabber-history-enabled t)
 '(jabber-history-muc-enabled t)
 '(jabber-invalid-certificate-servers (quote ("mel-imsrv1" "mel-imsrv1.devel.iress.com.au" "mel-imsrv1/nil")) t)
 '(jabber-keepalive-interval 30)
 '(jabber-libnotify-method (quote dbus))
 '(jabber-roster-line-format "%c %-25n %u %-8s  %S")
 '(jabber-use-auth-sources t)
 '(jabber-use-global-history nil)
 '(lazy-highlight-cleanup nil)
 '(lazy-highlight-initial-delay 0)
 '(lazy-highlight-max-at-a-time nil)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-verbosity (quote nil))
 '(newsticker-url-list (quote (("FastCompany" "http://www.fastcompany.com/rss.xml" nil nil nil) ("TheNextWeb" "http://feeds2.feedburner.com/thenextweb" nil nil nil) ("BoingBoing" "http://feeds.boingboing.net/boingboing/iBag" nil nil nil) ("TechRepublic" "http://www.techrepublic.com/search?t=1&o=1&mode=rss" nil nil nil) ("TechCrunch" "http://feeds.feedburner.com/TechCrunch/" nil nil nil))))
 '(notmuch-saved-searches (quote (("unread" . "tag:unread") ("sent/replied" . "tag:sent tag:replied and date:30d..0s") ("inbox" . "(tag:INBOX or  tag:inbox) and not tag:osc and date:30d..0s") ("osc" . "tag:osc") ("osc_note" . "tag:osc  and \"a NOTE has been added\""))))
 '(notmuch-search-hook (quote (notmuch-hl-line-mode)))
 '(notmuch-search-line-faces (quote (("deleted" :foreground "red" :background "blue") ("unread" :foreground "green") ("flagged" :foreground "magenta") ("me" :weight bold :foreground "white") ("INBOX" :foreground "color-243"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-show-indent-multipart t)
 '(notmuch-show-only-matching-messages t)
 '(org-directory "~/Dropbox/OrgMode")
 '(org-mobile-directory "~/Dropbox/MobileOrg")
 '(org-mobile-inbox-for-pull "~/Dropbox/MobileOrg/mobileorg.org")
 '(org-todo-keywords (quote ((sequence "TODO" "DONE" "CANCELED"))))
 '(paredit-mode nil t)
 '(password-cache-expiry nil)
 '(recentf-mode t)
 '(repository-root-matchers (quote (repository-root-matcher/git repository-root-matcher/svn)))
 '(scss-compile-at-save nil)
 '(send-mail-function (quote mailclient-send-it))
 '(shell-file-name "/bin/sh")
 '(split-width-threshold 105)
 '(split-window-keep-point nil)
 '(url-handler-mode t)
 '(url-handler-regexp "\\`\\(\\(https?\\|ftp\\|file\\|nfs\\)://|File\\)")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map (quote ((20 . "#dc322f") (40 . "#cb4b16") (60 . "#b58900") (80 . "#859900") (100 . "#2aa198") (120 . "#268bd2") (140 . "#d33682") (160 . "#6c71c4") (180 . "#dc322f") (200 . "#cb4b16") (220 . "#b58900") (240 . "#859900") (260 . "#2aa198") (280 . "#268bd2") (300 . "#d33682") (320 . "#6c71c4") (340 . "#dc322f") (360 . "#cb4b16"))))
 '(vc-annotate-very-old-color nil)
 '(xclip-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "unspecified-bg" :foreground "#FFFFFF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(column-marker-1 ((t (:background "color-53"))))
 '(cscope-line-face ((t nil)))
 '(cursor ((t (:background "light slate blue" :foreground "#888888"))))
 '(diredp-date-time ((((type tty)) :foreground "yellow") (t :foreground "goldenrod1")))
 '(diredp-dir-heading ((((type tty)) :background "yellow" :foreground "blue") (t :background "Pink" :foreground "DarkOrchid1")))
 '(diredp-dir-priv ((t (:background "color-16" :foreground "color-21"))))
 '(diredp-display-msg ((((type tty)) :foreground "blue") (t :foreground "cornflower blue")))
 '(diredp-file-name ((t nil)))
 '(diredp-file-suffix ((t nil)))
 '(ediff-current-diff-A ((t (:background "color-17" :foreground "white"))))
 '(ediff-current-diff-B ((t (:background "color-17" :foreground "white"))))
 '(ediff-even-diff-A ((t (:background "color-237" :foreground "Black"))))
 '(ediff-even-diff-B ((t (:background "color-239" :foreground "White"))))
 '(ediff-odd-diff-A ((t (:background "color-239" :foreground "White"))))
 '(ediff-odd-diff-B ((t (:background "color-239" :foreground "Black"))))
 '(flycheck-error ((t (:underline (:color "red" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "red" :style wave)))))
 '(flymake-errline ((t (:background "color-124"))))
 '(flymake-warnline ((t (:background "color-161"))))
 '(helm-selection ((t (:background "color-17" :underline t))))
 '(helm-source-header ((t (:background "color-18" :foreground "black" :weight bold :height 1.3 :family "Sans Serif"))))
 '(helm-visible-mark ((t (:background "color-17"))))
 '(icicle-candidate-part ((t (:background "color-17"))))
 '(icicle-current-candidate-highlight ((t (:background "color-19"))))
 '(icicle-extra-candidate ((t (:background "color-17"))))
 '(icicle-input-completion-fail ((t (:background "color-88" :foreground "Black"))))
 '(icicle-input-completion-fail-lax ((t (:background "color-53" :foreground "Black"))))
 '(icicle-proxy-candidate ((t (:background "color-17" :box (:line-width 2 :color "White" :style released-button)))))
 '(icicle-saved-candidate ((t (:background "color-17"))))
 '(icicle-special-candidate ((t (:background "color-19"))))
 '(idle-highlight ((t (:background "color-234"))))
 '(log-view-message ((t nil)))
 '(magit-header ((t (:inherit header-line :background "white" :foreground "black"))))
 '(match ((t (:background "color-22"))))
 '(mode-line ((t (:background "#262626" :foreground "#262626" :inverse-video t :box nil :underline nil :slant normal :weight normal))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#494949" :foreground "#494949" :inverse-video t :box nil :underline nil :slant normal :weight normal))))
 '(notmuch-message-summary-face ((t (:background "color-17"))))
 '(notmuch-tag-face ((t (:foreground "color-19"))))
 '(rst-level-1 ((t (:background "color-236"))) t)
 '(vertical-border ((t (:inherit mode-line-inactive :background "grey" :foreground "grey" :weight thin :width condensed)))))
(put 'narrow-to-region 'disabled nil)

(defun hs-hide-leafs-recursive (minp maxp)
  "Hide blocks below point that do not contain further blocks in
    region (MINP MAXP)."
  (when (hs-find-block-beginning)
    (setq minp (1+ (point)))
    (funcall hs-forward-sexp-func 1)
    (setq maxp (1- (point))))
  (unless hs-allow-nesting
    (hs-discard-overlays minp maxp))
  (goto-char minp)
  (let ((leaf t))
    (while (progn
             (forward-comment (buffer-size))
             (and (< (point) maxp)
                  (re-search-forward hs-block-start-regexp maxp t)))
      (setq pos (match-beginning hs-block-start-mdata-select))
      (if (hs-hide-leafs-recursive minp maxp)
          (save-excursion
            (goto-char pos)
            (hs-hide-block-at-point t)))
      (setq leaf nil))
    (goto-char maxp)
    leaf))

(defun hs-hide-leafs ()
  "Hide all blocks in the buffer that do not contain subordinate
    blocks.  The hook `hs-hide-hook' is run; see `run-hooks'."
  (interactive)
  (hs-life-goes-on
   (save-excursion
     (message "Hiding blocks ...")
     (save-excursion
       (goto-char (point-min))
       (hs-hide-leafs-recursive (point-min) (point-max)))
     (message "Hiding blocks ... done"))
          (run-hooks 'hs-hide-hook)))

(put 'dired-find-alternate-file 'disabled nil)

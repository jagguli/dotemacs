; define function to shutdown emacs server instance
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

(load-file "~/.emacs.d/packages.el")
(load-file "~/.emacs.d/emacs.el")
(load-file "~/.emacs.d/modules.el")
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))

;; https://github.com/Bruce-Connor/smart-mode-line/issues/88
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(async-bytecomp-package-mode 1)
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#4d4d4c" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#ffffff"))
 '(auth-source-protocols
   (quote
    ((imap "imap" "imaps" "143" "993")
     (pop3 "pop3" "pop" "pop3s" "110" "995")
     (ssh "ssh" "22")
     (sftp "sftp" "115"))))
 '(auto-revert-interval 0.5)
 '(background-color nil)
 '(background-mode dark)
 '(bmkp-last-as-first-bookmark-file "~/share/Dropbox/.emacsbookmarks")
 '(bookmark-default-file (expand-file-name "~/share/Dropbox/.emacsbookmarks"))
 '(bookmark-version-control (quote nospecial))
 '(browse-url-browser-function (quote browse-url-chromium))
 '(browse-url-chromium-program "chromium")
 '(col-highlight-overlay-priority -300)
 '(col-highlight-vline-face-flag nil)
 '(column-highlight-mode t)
 '(compilation-disable-input t)
 '(cursor-color nil)
 '(custom-safe-themes
   (quote
    ("bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "3a727bdc09a7a141e58925258b6e873c65ccf393b2240c51553098ca93957723" default)))
 '(diary-file "~/org/diary")
 '(dictionary-proxy-port 80)
 '(dictionary-proxy-server "syd-devproxy1.devel.iress.com.au")
 '(dictionary-use-http-proxy t)
 '(dired-omit-files "^\\.[^.]+.*$")
 '(docs-source
   (helm-cmd-t-get-create-source-dir
    (expand-file-name "~/share/Dropbox/OrgMode")))
 '(downloads-source (helm-cmd-t-get-create-source-dir "~/"))
 '(ecb-activation-selects-ecb-frame-if-already-active t)
 '(ecb-options-version "2.40")
 '(ecb-source-file-regexps
   (quote
    ((".*"
      ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)")
      ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote ("/home/steven/iress/xplan/" "/home/steven/iress")))
 '(ecb-tree-indent 2)
 '(ecb-vc-enable-support nil)
 '(ediff-split-window-function (quote split-window-right))
 '(elmo-imap4-default-port 1143)
 '(elmo-imap4-default-user "steven.joseph")
 '(erc-autojoin-channels-alist
   (quote
    ((".*\\.freenode.net" "#emacs" "#python" "#archlinux")
     (".*\\.oftc.net" "#suckless"))))
 '(erc-autojoin-mode t)
 '(erc-button-mode t)
 '(erc-fill-mode t)
 '(erc-hide-list (quote ("JOIN" "NICK" "PART" "QUIT" "MODE")))
 '(erc-irccontrols-mode t)
 '(erc-list-mode t)
 '(erc-match-mode t)
 '(erc-menu-mode t)
 '(erc-move-to-prompt-mode t)
 '(erc-netsplit-mode t)
 '(erc-networks-mode t)
 '(erc-nick "jagguli")
 '(erc-noncommands-mode t)
 '(erc-pcomplete-mode t)
 '(erc-readonly-mode t)
 '(erc-ring-mode t)
 '(erc-stamp-mode t)
 '(erc-track-minor-mode t)
 '(erc-track-mode t)
 '(erc-track-position-in-mode-line t)
 '(evil-ex-hl-update-delay 0.1)
 '(evil-fold-level 1)
 '(evil-search-module (quote evil-search))
 '(fci-rule-color "#073642")
 '(ffap-machine-p-known (quote reject))
 '(flycheck-check-syntax-automatically (quote (save mode-enabled)))
 '(flycheck-checker-error-threshold 5000)
 '(flycheck-checkers
   (quote
    (coffee-coffeelint css-csslint elixir emacs-lisp emacs-lisp-checkdoc erlang go-gofmt go-build go-test haml html-tidy javascript-jshint json-jsonlint lua perl php php-phpcs puppet-parser puppet-lint python-flake8 python-pylint rst ruby-rubocop ruby ruby-jruby rust sass scala scss sh-bash tex-chktex tex-lacheck xml-xmlstarlet)))
 '(flycheck-idle-change-delay 5)
 '(flycheck-yaml-jsyaml-executable "/home/steven/.npm/bin/js-yaml")
 '(foreground-color nil)
 '(fortune-dir "/usr/share/fortune/")
 '(gmm-tool-bar-style (quote retro))
 '(grep-command "ack --with-filename --nogroup --all")
 '(grep-highlight-matches (quote auto))
 '(gud-pdb-command-name "python -d")
 '(helm-locate-command "locate %s -e -r %s")
 '(helm-locate-project-list (quote ("~/iress/")))
 '(idle-highlight-idle-time 1.5)
 '(idle-update-delay 1.5)
 '(itail-fancy-mode-line t)
 '(itail-highlight-list
   (quote
    (("Error" . hi-red-b)
     ("GET\\|POST\\|DELETE\\|PUT" . hi-green-b)
     ("[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}" . font-lock-string-face)
     ("File \\\".*\\\"" . hi-red-b)
     ("^Traceback.*$" . hi-red-b))))
 '(jabber-account-list nil)
 '(jabber-alert-info-message-hooks
   (quote
    (jabber-info-tmux jabber-info-switch jabber-info-echo)) t)
 '(jabber-alert-message-hooks
   (quote
    (jabber-message-notifications jabber-message-switch jabber-message-echo jabber-message-libnotify)) t)
 '(jabber-alert-message-wave "~/.sounds/message-new-instant.wav" t)
 '(jabber-alert-muc-hooks
   (quote
    (jabber-muc-libnotify jabber-muc-echo jabber-muc-switch jabber-muc-display jabber-muc-scroll)))
 '(jabber-auto-reconnect t t)
 '(jabber-autoaway-priority 0 t)
 '(jabber-autoaway-verbose t t)
 '(jabber-autoaway-xa-priority 0 t)
 '(jabber-backlog-days 30 t)
 '(jabber-backlog-number 40 t)
 '(jabber-default-priority 300 t)
 '(jabber-default-show "chat" t)
 '(jabber-default-status "can I automate it ?" t)
 '(jabber-history-enable-rotation t t)
 '(jabber-history-enabled t t)
 '(jabber-history-muc-enabled t t)
 '(jabber-keepalive-interval 30 t)
 '(jabber-mode-line-mode t t)
 '(jabber-roster-line-format "%c %-25n %u %-8s  %S" t)
 '(jabber-show-offline-contacts t t)
 '(jedi:install-python-jedi-dev-command
   (quote
    ("pip2" "install" "--upgrade" "git+https://github.com/davidhalter/jedi.git@dev#egg=jedi")))
 '(js3-indent-level 4)
 '(lazy-highlight-cleanup nil)
 '(lazy-highlight-initial-delay 0)
 '(lazy-highlight-max-at-a-time nil)
 '(line-number-mode t)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-verbosity (quote nil))
 '(magit-repo-dirs (quote ("/home/steven/iress")))
 '(mml-enable-flowed nil)
 '(mu4e-compose-signature "Sent with emacs - the one true editor.")
 '(newsticker-html-renderer (quote w3m-region))
 '(newsticker-retrieval-method (quote extern))
 '(newsticker-url-list
   (quote
    (("FastCompany" "http://www.fastcompany.com/rss.xml" nil nil nil)
     ("TheNextWeb" "http://feeds2.feedburner.com/thenextweb" nil nil nil)
     ("BoingBoing" "http://feeds.boingboing.net/boingboing/iBag" nil nil nil)
     ("TechRepublic" "http://www.techrepublic.com/search?t=1&o=1&mode=rss" nil nil nil)
     ("TechCrunch" "http://feeds.feedburner.com/TechCrunch/" nil nil nil)
     ("Archlinux" "https://www.archlinux.org/feeds/news/" nil nil nil))))
 '(notmuch-address-command "~/.bin/mutt_ldap.py")
 '(notmuch-identities (quote ("steven.joseph@iress.com.au")))
 '(notmuch-saved-searches
   (quote
    ((:name "unread" :query "tag:unread")
     (:name "sent/replied" :query "tag:sent tag:replied and date:30d..0s")
     (:name "inbox" :query "(tag:INBOX or  tag:inbox) and not (tag:manup or tag:osc or tag:misc) and date:30d..0s" :key "i")
     (:name "osc" :query "tag:osc")
     (:name "osc_note" :query "tag:osc  and \"a NOTE has been added\"")
     (:name "nomailers" :query "not tag:mailers")
     (:name "misc" :query "tag:misc")
     (:name "last30days" :query "date:30d..0s")
     (:name "me" :query "tag:me and (tag:INBOX or  tag:inbox) and not (tag:osc or tag:misc) and date:30d..0s or (tag:sent or tag:replied or from:steven.joseph) " :key "m")
     (:name "unread_me" :query "tag:me and (tag:INBOX or  tag:inbox) and not (tag:osc or tag:misc) and date:30d..0s and tag:unread and (tag:sent or tag:replied or from:steven.joseph)")
     (:name "calendar" :query "mimetype:text/calendar" :key "c")
     (:name "Wire" :query "from:iress@jiveon.com" :key "w"))))
 '(notmuch-search-hook (quote (notmuch-hl-line-mode)))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(notmuch-show-empty-saved-searches t)
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-show-indent-multipart nil)
 '(notmuch-show-insert-text/plain-hook
   (quote
    (notmuch-wash-convert-inline-patch-to-part notmuch-wash-wrap-long-lines notmuch-wash-tidy-citations notmuch-wash-elide-blank-lines notmuch-wash-excerpt-citations)))
 '(notmuch-show-only-matching-messages t)
 '(notmuch-show-part-button-default-action (quote notmuch-show-view-part))
 '(notmuch-tree-show-out t)
 '(notmuch-wash-citation-lines-prefix 0)
 '(notmuch-wash-original-regexp "^\\(From: .*\\|.* writes:\\)$")
 '(notmuch-wash-wrap-lines-length 70)
 '(org-agenda-files (quote ("/home/steven/org/")))
 '(org-agenda-repeating-timestamp-show-all nil)
 '(org-agenda-skip-scheduled-if-deadline-is-shown (quote repeated-after-deadline))
 '(paredit-mode nil t)
 '(password-cache-expiry nil)
 '(py-complete-function (quote py-indent-or-complete))
 '(py-ffap-p (quote py-ffap))
 '(py-shell-name "python2")
 '(recentf-auto-cleanup 300)
 '(recentf-max-menu-items 500)
 '(recentf-max-saved-items 500)
 '(recentf-mode t)
 '(repository-root-matchers
   (quote
    (repository-root-matcher/git repository-root-matcher/svn)))
 '(req-package-log-level (quote debug))
 '(ropemacs-confirm-saving nil)
 '(ropemacs-global-prefix "C-x @")
 '(scss-compile-at-save nil)
 '(shell-file-name "/bin/sh")
 '(split-height-threshold 200)
 '(split-width-threshold 155)
 '(split-window-keep-point nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(url-handler-mode nil)
 '(url-handler-regexp "\\`\\(\\(https?\\|ftp\\|file\\|nfs\\)://|File\\)")
 '(url-proxy-services nil)
 '(user-full-name "Steven Joseph")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#cb4b16")
     (60 . "#b58900")
     (80 . "#859900")
     (100 . "#2aa198")
     (120 . "#268bd2")
     (140 . "#d33682")
     (160 . "#6c71c4")
     (180 . "#dc322f")
     (200 . "#cb4b16")
     (220 . "#b58900")
     (240 . "#859900")
     (260 . "#2aa198")
     (280 . "#268bd2")
     (300 . "#d33682")
     (320 . "#6c71c4")
     (340 . "#dc322f")
     (360 . "#cb4b16"))))
 '(vc-annotate-very-old-color nil)
 '(wiki-directories (quote ("/home/steven/iress/devwiki/")))
 '(x-select-enable-clipboard nil)
 '(x-select-enable-primary nil)
 '(xclip-mode nil))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "#FFFFFF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(bmkp-local-file-without-region ((t (:foreground "green"))))
 '(col-highlight ((t (:background "color-233"))))
 '(column-marker-1 ((t (:background "color-232"))))
 '(cscope-line-face ((t nil)))
 '(cursor ((t (:background "light slate blue" :foreground "#888888"))))
 '(diredp-date-time ((((type tty)) :foreground "yellow") (t :foreground "goldenrod1")))
 '(diredp-dir-heading ((((type tty)) :background "yellow" :foreground "blue") (t :background "Pink" :foreground "DarkOrchid1")))
 '(diredp-dir-priv ((t (:background "color-16" :foreground "color-51"))))
 '(diredp-display-msg ((((type tty)) :foreground "blue") (t :foreground "cornflower blue")) t)
 '(diredp-file-name ((t nil)))
 '(diredp-file-suffix ((t nil)))
 '(ediff-current-diff-A ((t (:background "color-17" :foreground "white"))))
 '(ediff-current-diff-B ((t (:background "color-17" :foreground "white"))))
 '(ediff-even-diff-A ((t (:background "color-237" :foreground "Black"))))
 '(ediff-even-diff-B ((t (:background "color-239" :foreground "White"))))
 '(ediff-odd-diff-A ((t (:background "color-239" :foreground "White"))))
 '(ediff-odd-diff-B ((t (:background "color-239" :foreground "Black"))))
 '(flycheck-error ((t (:background "color-89"))))
 '(flycheck-warning ((t (:background "color-89"))))
 '(flymake-errline ((t (:background "color-124"))))
 '(flymake-warnline ((t (:background "color-161"))))
 '(helm-ff-directory ((t (:background "color-18" :foreground "white"))))
 '(helm-selection ((t (:background "color-232" :foreground "color-226" :weight extra-bold))))
 '(helm-source-header ((t (:background "color-18" :foreground "black" :weight bold :height 1.3 :family "Sans Serif"))))
 '(helm-visible-mark ((t (:background "color-17"))))
 '(hl-line ((t (:background "color-232" :weight bold))))
 '(icicle-candidate-part ((t (:background "color-17"))) t)
 '(icicle-current-candidate-highlight ((t (:background "color-19"))) t)
 '(icicle-extra-candidate ((t (:background "color-17"))) t)
 '(icicle-input-completion-fail ((t (:background "color-88" :foreground "Black"))) t)
 '(icicle-input-completion-fail-lax ((t (:background "color-53" :foreground "Black"))) t)
 '(icicle-proxy-candidate ((t (:background "color-17" :box (:line-width 2 :color "White" :style released-button)))) t)
 '(icicle-saved-candidate ((t (:background "color-17"))) t)
 '(icicle-special-candidate ((t (:background "color-19"))) t)
 '(idle-highlight ((t (:background "color-17"))) t)
 '(log-view-message ((t nil)) t)
 '(magit-header ((t (:inherit header-line :background "white" :foreground "black"))) t)
 '(match ((t (:background "color-22"))))
 '(notmuch-message-summary-face ((t (:background "color-17"))))
 '(notmuch-tag-face ((t (:foreground "color-19"))))
 '(rst-level-1 ((t (:background "color-236"))))
 '(trailing-whitespace ((t (:background "color-54" :foreground "color-54" :inverse-video t :underline nil :slant normal :weight normal))))
 '(vertical-border ((t (:inherit mode-line-inactive :background "black" :foreground "color-27" :weight thin :width condensed))))
 '(vline ((t (:background "color-233"))))
 '(vline-visual ((t (:background "color-234")))))

(put 'scroll-left 'disabled nil)

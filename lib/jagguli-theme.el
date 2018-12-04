(deftheme jagguli
  "Created 2014-08-24.")

(custom-theme-set-variables
 'jagguli
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ansi-color-faces-vector [default bold shadow italic underline bold bold-italic bold])
 '(auth-source-protocols (quote ((imap "imap" "imaps" "143" "993") (pop3 "pop3" "pop" "pop3s" "110" "995") (ssh "ssh" "22") (sftp "sftp" "115") (smtp "smtp" "25") (jabber "jabber-client" "5222"))))
 '(auth-sources (quote ("~/.authinfo"))))

(custom-theme-set-faces
 'jagguli
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "#FFFFFF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(bmkp-local-file-without-region ((t (:foreground "green"))))
 '(col-highlight ((t (:background "color-237"))))
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
 '(helm-ff-directory ((t (:background "color-18" :foreground "white"))))
 '(helm-selection ((t (:background "color-232" :foreground "color-226" :weight extra-bold))))
 '(helm-source-header ((t (:background "color-18" :foreground "black" :weight bold :height 1.3 :family "Sans Serif"))))
 '(helm-visible-mark ((t (:background "color-17"))))
 '(log-view-message ((t nil)))
 '(match ((t (:background "color-22"))))
 '(notmuch-message-summary-face ((t (:background "color-17"))))
 '(notmuch-tag-face ((t (:foreground "color-19"))))
 '(trailing-whitespace ((t (:background "color-54" :foreground "color-54" :inverse-video t :underline nil :slant normal :weight normal))))
 '(vertical-border ((t (:inherit mode-line-inactive :background "grey" :foreground "grey" :weight thin :width condensed)))))

(provide-theme 'jagguli)

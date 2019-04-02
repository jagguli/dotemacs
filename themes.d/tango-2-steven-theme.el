(deftheme tango-2-steven
  "Created 2012-05-31.")

(custom-theme-set-faces
 'tango-2-steven
 '(cursor ((t (:foreground "#2F4F4F"))))
 '(region ((t (:background "color-235"))))
 '(highlight ((t (:background "#222222"))))
 '(mode-line ((t (:foreground "#BCBf91" :background "#003d00"))))
 '(mode-line-inactive ((t (:background "#111111" :foreground "#cccddd"))))
 '(fringe ((t (:background "#000000"))))
 '(minibuffer-prompt ((t (:foreground "#729fcf"))))
 '(font-lock-builtin-face ((t (:foreground "#729fcf"))))
 '(font-lock-comment-face ((t (:foreground "#888a85"))))
 '(font-lock-constant-face ((t (:foreground "#ad7fa8"))))
 '(font-lock-function-name-face ((t (:foreground "#729fcf"))))
 '(font-lock-keyword-face ((t (:foreground "#fcaf3e"))))
 '(font-lock-string-face ((t (:foreground "#73d216"))))
 '(font-lock-type-face ((t (:foreground "#c17d11"))))
 '(font-lock-variable-name-face ((t (:foreground "#fce94f"))))
 '(font-lock-warning-face ((t (:bold t :foreground "#cc0000"))))
 '(link ((t (:foreground "#729fcf"))))
 '(link-visited ((t (:foreground "#ad7fa8"))))
 '(flyspell-duplicate ((t (:foreground "#fcaf3e"))))
 '(flyspell-incorrect ((t (:foreground "#cc0000"))))
 '(org-date ((t (:foreground "LightSteelBlue" :underline t))))
 '(org-hide ((t (:foreground "#2e3436"))))
 '(org-todo ((t (:inherit font-lock-keyword-face :bold t))))
 '(org-level-1 ((t (:inherit font-lock-function-name-face))))
 '(org-level-2 ((t (:inherit font-lock-variable-name-face))))
 '(org-level-3 ((t (:inherit font-lock-keyword-face))))
 '(org-level-4 ((t (:inherit font-lock-string-face))))
 '(org-level-5 ((t (:inherit font-lock-constant-face))))
 '(comint-highlight-input ((t (:italic t :bold t))))
 '(comint-highlight-prompt ((t (:foreground "#8ae234"))))
 '(isearch ((t (:background "#f57900" :foreground "#2e3436"))))
 '(lazy-highlight ((t (:foreground "#2e3436" :background "#e9b96e"))))
 '(paren-face-match ((t (:inherit show-paren-match-face))))
 '(paren-face-match-light ((t (:inherit show-paren-match-face))))
 '(paren-face-mismatch ((t (:inherit show-paren-mismatch-face))))
 '(persp-selected-face ((t (:foreground "#729fcf"))))
 '(show-paren-match ((t (:background "#729fcf" :foreground "#eeeeec"))))
 '(show-paren-mismatch ((t (:background "#ad7fa8" :foreground "#2e3436"))))
 '(vertical-border ((t (:inherit mode-line-inactive :background "black" :foreground "color-27" :weight thin :width condensed))))
 '(default ((t (:background "black" :foreground "#eeeeec")))))

(provide-theme 'tango-2-steven)

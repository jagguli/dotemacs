;; CScope =============================================================================
(require 'xcscope)
(setq cscope-do-not-update-database t)

(defun cscope-mappings()
  (interactive)
  (define-key evil-normal-state-map (kbd "C-c ]") 'cscope-find-global-definition-no-prompting)
  (evil-define-key 'normal evil-normal-state-map "C-c d" 'cscope-find-symbol)
  (evil-define-key 'normal evil-normal-state-map "C-c t" 'cscope-find-global-definition-no-prompting)
  (define-key evil-normal-state-map (kbd "C-c t") 'cscope-pop-mark)
  (evil-declare-key 'motion cscope-list-entry-keymap (kbd "<return>") 'cscope-select-entry-other-window)
  (evil-declare-key 'motion cscope-list-entry-keymap (kbd "RET") 'cscope-select-entry-other-window))

(cscope-mappings)

(add-hook 'cscope-list-entry-hook 
      #'(lambda ()
            (setq w (get-buffer-window "*cscope*"))
            (select-window w)
            (setq h (window-height w))
            (shrink-window (- h 15))
            ;;(print "cscope-list-entry-hook")
            ))
(add-hook 'cscope-minor-mode-hooks 'cscope-mappings)



(defun cscope-find-this-symbol-popup (symbol)
  "Locate a symbol in source code."
  (interactive (list
		(cscope-prompt-for-symbol "Find this symbol: " nil)))
  (let ( (cscope-adjust t) )	 ;; Use fuzzy matching.
    ;;(setq cscope-display-cscope-buffer nil)
    ;;(setq cscope-symbol symbol)
    (message (cscope-call (format "Finding symbol: %s" symbol)
		 (list "-0" symbol) nil ))
    ;;(setq cscope-display-cscope-buffer t)
    ))

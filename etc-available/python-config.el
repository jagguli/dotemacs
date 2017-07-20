;; Python Mode ================================================================================ 
;;;(require 'python-magic)
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-exec "pymacs" nil t)
;(autoload 'pymacs-load "pymacs" nil t)
;(autoload 'pymacs-autoload "pymacs")
;(setq ropemacs-enable-autoimport t)
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(req-package python-mode
  :require (
            evil
            multi-project
            column-marker
            )
  :config
  (setq
     py-load-pymacs-p nil
     pymacs-python-command "python2"
     ropemacs-confirm-saving 'nil
     pymacs-load-path 'nil
     ropemacs-global-prefix "C-x @"
     ropemacs-enable-autoimport t
     )
  :init
  (progn
    ;(autoload 'pymacs-apply "pymacs")
    ;(autoload 'pymacs-call "pymacs")
    ;(autoload 'pymacs-eval "pymacs" nil t)
    ;(autoload 'pymacs-exec "pymacs" nil t)
    ;(autoload 'pymacs-load "pymacs" nil t)
    (defun load-ropemacs()
      (interactive)
      (require 'pymacs)
      (pymacs-load "ropemacs" "rope-")
      )

    (global-set-key "\C-xpl" 'load-ropemacs)
    (add-hook 'outline-minor-mode-hook (lambda () 
                                         (require 'outline-magic)))

    (defadvice goto-line (after expand-after-goto-line
                                activate compile)
      "hideshow-expand affected block when using goto-line in a collapsed buffer"
      (save-excursion
      (ignore-errors (show-subtree))))

    (defadvice evil-goto-line (after expand-after-goto-line
                                activate compile)
      "hideshow-expand affected block when using goto-line in a collapsed buffer"
      (save-excursion
      (ignore-errors (show-subtree))))


    (defun string/starts-with (s begins)
          "returns non-nil if string S starts with BEGINS.  Else nil."
          (cond ((>= (length s) (length begins))
                 (string-equal (substring s 0 (length begins)) begins))
                (t nil)))

    (set-display-table-slot standard-display-table
                            'selective-display
                            (string-to-vector " [...]\n"))
    ;;;;http://emacs-fu.blogspot.com.au/2008/12/showing-and-hiding-blocks-of-code.html
    (defun my-python-mode-hook ()
      (interactive)
      (column-marker-1 80)
      (if (< (count-lines (point-min) (point-max)) 2000) 
          (flycheck-mode) 
        (flycheck-mode -1))
      (flyspell-prog-mode)

      (if (not (or
                (string/starts-with (buffer-name) "*mo-git-blame")
                (string/starts-with (buffer-name) "*svn-status")
                (bound-and-true-p diff-auto-refine-mode)
                ))
          (progn
            (setq
             outline-regexp "[ \t]*\\(class\\|def\\|with\\) "
             indent-line-function 'py-indent-line
            )
            (outline-minor-mode t)
            (define-key evil-normal-state-map "za" 'outline-cycle)
            (define-key evil-normal-state-map "\t" 'outline-cycle)
            (hide-body)
            (show-paren-mode 1)
            (define-key evil-normal-state-map "zo" 'show-entry)
            (define-key evil-normal-state-map "zO" 'hide-other)
            (define-key evil-normal-state-map "zc" 'hide-entry)
            (define-key evil-normal-state-map "zr" 'show-subtree)
            (define-key evil-normal-state-map "zR" 'show-all)
            (define-key evil-normal-state-map "zm" 'hide-body)
            (define-key evil-normal-state-map "zM" 'hide-sublevels)
            (define-key evil-normal-state-map "=" 'py-indent-line)
            (define-key evil-normal-state-map [(meta up)] 'py-up-class)
            (define-key evil-normal-state-map [(meta down)] 'py-down-class)
            (evil-define-key 'normal python-mode-map
             (kbd "C-c C-c") 'py-indent-line
             )
                                                          
            (define-key evil-normal-state-map (kbd "C-i")  'evil-jump-forward)
            )
        )
      )

    (add-hook 'python-mode-hook 'my-python-mode-hook)


    (defun pep8fix ()
        "Execute autopep8 on current file"
        (interactive)
        (let (suffixMap fName suffix progName cmdStr)

              ;; a keyed list of file suffix to comand-line program
    ;; path/name
          (setq suffixMap
                '(("py" . "autopep8 -i")))

          (setq fName (buffer-file-name))
          (setq suffix (file-name-extension fName))
          (setq progName (cdr (assoc suffix suffixMap)))
          (setq cmdStr (concat progName " \""   fName "\""))

          (if progName
              (progn
                (message "Running…")
                (shell-command cmdStr "*run-current-file output*")
                (revert-buffer)))))


    ;; Debug statements ==================================================================

    (defvar python-debugger "sj" "the debugger to use to set/unset breakpoints")
    (defun breakpoint-set nil
      (interactive)
      (save-excursion 
        (evil-open-below 1)
        (insert (format "import %s; %s.set_trace() ######## FIXME:REMOVE ME steven.joseph ################"
                        python-debugger python-debugger)) 
      ;;(highlight-lines-matching-regexp "^[ ]*import fpdb; fpdb.set_trace().*")))
        (highlight-lines-matching-regexp (format "^[ ]*import %s; %s.set_trace().*"
                                                 python-debugger python-debugger))))



    (defun breakpoint-uset nil
      (interactive)
      (save-excursion 
        (goto-char (point-min))
        (flush-lines (format "^[ ]*import %s; %s.set_trace().*$" python-debugger python-debugger))))



    ;; Nose configuration ==========================================================

    (require 'nose)

    (add-to-list 'nose-project-names "/usr/sbin/nosetests3")


    (defun clear-breakpoints nil
      (interactive)
      (write-region "" nil (if (string-match ".*xplan.*" buffer-file-name)
                        "~/.xplanbreakpoints" "~/.cpdb/breakpoints")))

    (defun remove-breakpoint nil
      (interactive)
      (let ((bpfile (if (string-match ".*xplan.*" buffer-file-name)
                        "~/.xplanbreakpoints" "~/.cpdb/breakpoints"))
            (bpline (format "%s:%s" (buffer-file-name) (line-number-at-pos (point)))))
        (with-temp-buffer
          (insert-file-contents bpfile)
          (goto-char (point-min))
          (flush-lines bpline)
          (when (file-writable-p bpfile)
            (write-region (point-min) (point-max) bpfile)))))

    (defun add-breakpoint nil
      (interactive)
      (let ((bpfile (if (string-match ".*xplan.*" buffer-file-name)
                        "~/.xplanbreakpoints" "~/.cpdb/breakpoints"))
            (bpline (format "%s:%s" (buffer-file-name) (line-number-at-pos (point)))))
        (with-temp-buffer
          (insert-file-contents bpfile)
          (goto-char (point-min))
          (flush-lines bpline)
          (insert bpline)
          (insert "\n")
          (sort-lines nil (point-min) (point-max))
          (when (file-writable-p bpfile)
            (write-region (point-min) (point-max) bpfile)))))

    ;;(define-key global-map (kbd "S-<f8>" ) 'add-breakpoint)
    ;;(define-key global-map (kbd "S-<f7>" ) 'remove-breakpoint)
    (define-key global-map (kbd "<f8>" ) 'breakpoint-set)
    (define-key global-map (kbd "S-<f8>" ) 'breakpoint-uset)
    ;;; Indentation for python

    ;; Ignoring electric indentation
(defun electric-indent-ignore-python (char)
  "Ignore electric indentation for python-mode"
  (if (equal major-mode 'python-mode)
      'no-indent
    nil))
(add-hook 'electric-indent-functions 'electric-indent-ignore-python)

;; Enter key executes newline-and-indent
(defun set-newline-and-indent ()
  "Map the return key with `newline-and-indent'"
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'python-mode-hook 'set-newline-and-indent)
    )
  )

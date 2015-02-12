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
(req-package python
  :require (evil multi-project)
  :init
  (progn
    (defun load-ropemacs ()
      "Load pymacs and ropemacs"
      (interactive)
      (setq pymacs-python-command "/usr/bin/python2")
      (setenv "PYMACS_PYTHON" "python2.7")
      ;;(setq pymacs-load-path "/usr/lib/python2.7/")
      (setq ropemacs-global-prefix "C-x @")
      (require 'pymacs)
      (pymacs-load "ropemacs" "rope-")
      ;; Automatically save project python buffers before refactorings
      (setq ropemacs-confirm-saving 'nil)
    )

    ;;(load-ropemacs)
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

      (if (not (or
                (string/starts-with (buffer-name) "*mo-git-blame")
                (string/starts-with (buffer-name) "*svn-status")
                ))
          (progn
            (setq outline-regexp "[ \t]*\\(class\\|def\\|with\\) ")
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

    (defun breakpoint-set nil
      (interactive)
      (save-excursion 
        (next-line)
        (beginning-of-line)
        (insert "import sj; sj.debug() ######## FIXME:REMOVE ME steven.joseph ################\n")
        (previous-line)
        (python-indent-line)
      (highlight-lines-matching-regexp "^[ ]*import sj; sj.debug().*")))



    (defun breakpoint-uset nil
      (interactive)
      (save-excursion 
        (goto-char (point-min))
        (flush-lines "^[ ]*import sj; sj.debug().*$")))



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

    (define-key global-map (kbd "S-<f8>" ) 'add-breakpoint)
    (define-key global-map (kbd "S-<f7>" ) 'remove-breakpoint)
    (define-key global-map (kbd "<f8>" ) 'breakpoint-set)
    (define-key global-map (kbd "<f7>" ) 'breakpoint-uset)
    )
  )

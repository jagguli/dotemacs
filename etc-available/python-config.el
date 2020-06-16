;; package ---- Summary: Python Mode ===========================================
;;; Code:
(req-package python-mode
  :require (
            evil
            multi-project
            column-enforce-mode
            ;;anaconda-mode
            ;;company-anaconda
            outline-magic
            pipenv
            )
  :config
  (setq
   py-load-pymaqcs-p t
   pymacs-python-command "python"
   ropemacs-confirm-saving 'nil
   pymacs-load-path '(
                      "~/.local/lib/python3.8/site-packages"
                      "~/.local/share/virtualenvs/slicecloud-Y-bug9Ht/lib/python3.8/site-packages"
                      )
   ropemacs-global-prefix "C-x @"
   ropemacs-enable-autoimport t
   )
  :init
  (progn
    (interactive)

    (require 'pymacs)
    (pymacs-load "ropemacs" "rope-")

    (add-hook 'outline-minor-mode-hook 
            (lambda () 
                (require 'outline-magic)
    ))
    ;;(add-hook 'pipenv-mode-hook #'lsp)

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
    (defun py-outline-level ()
        (let (buffer-invisibility-spec)
            (save-excursion
            (skip-chars-forward "    ")
            (current-column))))
    ;;;;http://emacs-fu.blogspot.com.au/2008/12/showing-and-hiding-blocks-of-code.html
    (defun my-python-mode-hook ()
      (message "my-python-mode-hook")
      (interactive)
      ;;(anaconda-mode)
      (flycheck-mode)
      ;;(if (< (count-lines (point-min) (point-max)) 2000)
      ;;    (flycheck-mode)
      ;;  (flycheck-mode -1))
      (flyspell-prog-mode)

      (if (not (or
                (string/starts-with (buffer-name) "*mo-git-blame")
                (string/starts-with (buffer-name) "*svn-status")
                ))
          (progn
            (message "my-python-mode-hook:outline-mode")
            (setq 
                outline-regexp "[ \t]*\\(class\\|def\\|with\\) "
                indent-line-function 'py-indent-line
                outline-level 'py-outline-level
            )
            (outline-minor-mode t)
            (show-paren-mode 1)
            (outline-hide-body)
            (define-key python-mode-map [tab] 'outline-cycle)
            (define-key outline-minor-mode-map [S-tab] 'indent-for-tab-command)
            (define-key outline-minor-mode-map [M-down] 'outline-move-subtree-down)
            (define-key outline-minor-mode-map [M-up] 'outline-move-subtree-up)
            (define-key evil-normal-state-map "za" 'outline-toggle-children)
            (define-key evil-normal-state-map "\t" 'outline-cycle)
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
      (define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer)
      ;;(define-key evil-normal-state-local-map (kbd "C-]") 'anaconda-mode-find-definitions)
      ;;(define-key evil-normal-state-local-map (kbd "C-t") 'anaconda-mode-go-back)
      ;;(define-key evil-normal-state-local-map (kbd "C-M-]") 'anaconda-mode-find-references)
      ;;(define-key evil-insert-state-local-map (kbd "C-c SPC") 'jedi:complete)
      (define-key evil-normal-state-local-map (kbd "C-]") 'rope-goto-definition)
      (define-key evil-normal-state-local-map (kbd "C-o") 'rope-pop-mark)
      (define-key python-mode-map "\C-o" 'rope-pop-mark)
      (pipenv-mode)
      (pipenv-activate)
      )



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

    (defvar python-debugger "ipdb" "the debugger to use to set/unset breakpoints")
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
    (define-key global-map (kbd "M-<f8>" ) 'breakpoint-set)
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

    (defun my/python-switch-version ()
      (interactive)
      (setq python-shell-interpreter
            (if (string-equal python-shell-interpreter "python3") "python2" "python3"))
      ;;(setq elpy-rpc-backend
      ;;      (if (string-equal elpy-rpc-backend "python") "python3" "python"))
      (setq pymacs-python-command
            (if (string-equal pymacs-python-command "python2") "python3" "python2"))
      (message python-shell-interpreter))

    (add-hook 'python-mode-hook 'set-newline-and-indent)
    ;;(add-to-list 'company-backends 'company-anaconda)
    (add-hook 'python-mode-hook 'my-python-mode-hook)
    )
)

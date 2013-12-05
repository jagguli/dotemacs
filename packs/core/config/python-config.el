;; Python Mode ================================================================================ 
(require 'pymacs)
;;(require 'python-magic)
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-exec "pymacs" nil t)
;(autoload 'pymacs-load "pymacs" nil t)
;(autoload 'pymacs-autoload "pymacs")
;(pymacs-load "ropemacs" "rope-")
;(setq ropemacs-enable-autoimport t)
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(require 'column-marker)

(add-hook 'outline-minor-mode-hook 
           (lambda () 
             (require 'outline-magic)
))

(defadvice goto-line (after expand-after-goto-line
                            activate compile)
  "hideshow-expand affected block when using goto-line in a collapsed buffer"
  (save-excursion
  (show-subtree)))

(defadvice evil-goto-line (after expand-after-goto-line
                            activate compile)
  "hideshow-expand affected block when using goto-line in a collapsed buffer"
  (save-excursion
  (show-subtree)))

;;;;http://emacs-fu.blogspot.com.au/2008/12/showing-and-hiding-blocks-of-code.html
(add-hook 'python-mode-hook
      #'(lambda ()
    (column-marker-1 80)
    (if (boundp 'ediff-mode)  ()
        (progn
          (message "outline…")
          (if (< (count-lines (point-min) (point-max)) 2000) (flycheck-mode))
          (setq outline-regexp "[ \t]*\\(class\\|def\\|with\\) ")
          (outline-minor-mode t)
          (hide-body)
          (show-paren-mode 1)
          (define-key evil-normal-state-map "zo" 'show-entry)
          (define-key evil-normal-state-map "zO" 'hide-other)
          (define-key evil-normal-state-map "zc" 'hide-entry)
          (define-key evil-normal-state-map "za" 'outline-cycle)
          (define-key evil-normal-state-map "\t" 'outline-cycle)
          (define-key evil-normal-state-map "zr" 'show-subtree)
          (define-key evil-normal-state-map "zR" 'show-all)
          (define-key evil-normal-state-map "zm" 'hide-subtree)
          (define-key evil-normal-state-map "zM" 'hide-body)))
    ;;(setq autopair-handle-action-fns
      ;;(list #'autopair-default-handle-action
        ;;  #'autopair-python-triple-quote-action
    ))


;;(add-hook 'find-file-hook 'flymake-find-file-hook)
;;(when (load "flymake" t)
;;  (defun flymake-pyflakes-init ()
;;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                       'flymake-create-temp-inplace))
;;           (local-file (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;      (list "pycheckers"  (list local-file))))
;;  (add-to-list 'flymake-allowed-file-name-masks
;;               '("\\.py\\'" flymake-pyflakes-init)))
;;(load-library "flymake-cursor")
;;(global-set-key [f10] 'flymake-goto-prev-error)
;;(global-set-key [f11] 'flymake-goto-next-error)

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
(defvar buster-test-regexp
  "^#.*"
    "Regular expression that finds the beginning of a test function")

(defun breakpoint-set nil
  (interactive)
  (save-excursion 
    (next-line)
    (beginning-of-line)
    ;;(open-line)
    ;;(search-forward-regexp buster-test-regexp (point-at-eol) t)
    (insert "sj_debug() ###############################################################\n")
    (previous-line)
    (python-indent-line))
  (save-excursion 
    (goto-char (point-min))
    (flush-lines "^from.*sj_debug$")
    (goto-char (point-min))
    (if (search-forward-regexp "^#!.*$" (point-max) t)
        (next-line) (goto-char (point-min)))
    (insert "from debug import pprint, pprintxml, shell, profile, debug as sj_debug\n"))

  )
(define-key global-map (kbd "<f8>" ) 'breakpoint-set)
(defun breakpoint-uset nil
  (interactive)
  (save-excursion 
    (goto-char (point-min))
    (flush-lines "^from.*sj_debug$")
    (goto-char (point-min))
    (flush-lines ".*sj_debug().*"))
  )

(define-key global-map (kbd "<f7>" ) 'breakpoint-uset)
;; kill all other buffers
(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))

(defun popup-cscope-process-filter (process output)
  ;;(message process)
  (message output))

(defun popup-cscope-process-sentinel (process event)
  ;;(message process)
  (message event))

(defun cscope-popup ()
  (interactive)
  (let ( (symbol (cscope-extract-symbol-at-cursor nil))
	 (cscope-adjust t) )	 ;; Use fuzzy matching.
    (setq cscope-symbol symbol)
    (setq cscope-display-cscope-buffer nil)
    (cscope-call (format "Finding global definition: %s" symbol)
		 (list "-1" symbol) nil 'popup-cscope-process-filter
		 'popup-cscope-process-sentinel)))

(require 'nose)

(add-to-list 'nose-project-names "/usr/sbin/nosetests3")

;; Python Mode ================================================================================ 
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(require 'column-marker)

;;;;http://emacs-fu.blogspot.com.au/2008/12/showing-and-hiding-blocks-of-code.html
(add-hook 'python-mode-hook
      #'(lambda ()
    (local-set-key (kbd "C-c <right>") 'hs-show-block)
    (local-set-key (kbd "C-c <left>")  'hs-hide-block)
    (local-set-key (kbd "C-c <up>")    'hs-hide-all)
    (local-set-key (kbd "C-c <down>")  'hs-show-all)
    (column-marker-1 80)
    ;(local-set-key (kbd "C-]")  'cscope-find-symbol)
    ;;(hs-minor-mode t)
    ;;(hs-hide-all)
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
            (shell-command cmdStr "*run-current-file output*")))))


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
    (python-indent-line)
    (goto-char (point-min))
    (flush-lines "^from.*sj_debug$")
    (goto-char (point-min))
    (search-forward-regexp "^#!.*$" (point-at-eol) t)
    (insert "from debug import shell, debug as sj_debug\n"))
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

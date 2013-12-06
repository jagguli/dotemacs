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
(defun my-python-mode-hook ()
  (interactive)
  (column-marker-1 80)
  (if (< (count-lines (point-min) (point-max)) 2000) 
      (flycheck-mode) 
    (flycheck-mode -1))
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
  (define-key evil-normal-state-map "zM" 'hide-body))

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


;; Nose configuration ==========================================================

(require 'nose)

(add-to-list 'nose-project-names "/usr/sbin/nosetests3")

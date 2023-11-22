;; package ---- Summary: Python Mode ===========================================
(req-package lsp-jedi
  :ensure t)
;;; Code:
(req-package python-mode
  :require (
            evil
            multi-project
            column-enforce-mode
            ;;anaconda-mode
            ;;company-anaconda
            outline-magic
            poetry
            blacken
            porthole
            )
  :config
  (setq
   py-load-pymaqcs-p t
   pymacs-python-command "/usr/sbin/python"
   ropemacs-confirm-saving 'nil
   python-remove-cwd-from-path nil
   pymacs-load-path '(
                      "/usr/lib/python3.11/site-packages"
                      "~/.local/lib/python3.11/site-packages/"
                      )
   ropemacs-global-prefix "C-x @"
   ropemacs-enable-autoimport t
   blacken-executable "~/.local/bin/black"
   )
  :init
  (progn
    (interactive)

    (require 'pymacs)

    (add-hook 'outline-minor-mode-hook 
              (lambda () 
                (require 'outline-magic)
                ))
    ;; Activate flycheck-mode for all buffers
    (add-hook 'after-init-hook #'global-flycheck-mode)

    ;; Use flake8 for Python files
    (flycheck-add-mode 'python-flake8 'python-mode)

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
                (string/starts-with (buffer-name) "magit")
                (string/starts-with (buffer-name) "*mo-git-blame")
                (string/starts-with (buffer-name) "*svn-status")
                ))
          (progn
            (blacken-mode)
            (pymacs-load "ropemacs" "rope-")
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
            (define-key evil-normal-state-map [(meta up)] 'py-up-class)
            (define-key evil-normal-state-map [(meta down)] 'py-down-class)
            (evil-define-key 'normal python-mode-map
              (kbd "C-c C-c") 'py-indent-line
              )

            (define-key evil-normal-state-map (kbd "C-i")  'evil-jump-forward)
            (define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer)
            ;;(define-key evil-normal-state-local-map (kbd "C-]") 'anaconda-mode-find-definitions)
            ;;(define-key evil-normal-state-local-map (kbd "C-t") 'anaconda-mode-go-back)
            ;;(define-key evil-normal-state-local-map (kbd "C-M-]") 'anaconda-mode-find-references)
            ;;(define-key evil-insert-state-local-map (kbd "C-c SPC") 'jedi:complete)
            (define-key evil-normal-state-local-map (kbd "C-]") 'rope-goto-definition)
            (define-key evil-normal-state-local-map (kbd "C-o") 'rope-pop-mark)
            (define-key python-mode-map "\C-o" 'rope-pop-mark)
            )
        )
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
    ;; porthole
    (porthole-start-server "mypdb-server")
    ;; You need to tell the server which functions are allowed to be called remotely. We'll expose the `insert` function.
    (porthole-expose-function "mypdb-server" 'insert)
    (porthole-expose-function "mypdb-server" 'find-file)
    (porthole-expose-function "mypdb-server" 'forward-line)
    )
  )
                                        ;generate an emacs lisp function to take the output of flake8 and list the file names and line numbers into a  helm buffer
(require 'helm)
(defun my/flake8-errors ()
  "Display a Helm buffer with the file names and line numbers of flake8 errors."
  (interactive)
  (let ((output (shell-command-to-string "flake8 --max-line-length=80")))
    (with-current-buffer (get-buffer-create "*flake8 errors*")
      (erase-buffer)
      (insert output)
      (when (re-search-forward "\\(.+\\.py\\):\\([0-9]+\\):" nil t)
        (helm :sources (helm-build-sync-source "flake8 errors"
                         :candidates (list (cons (match-string 1) (match-string 2))))
              :buffer "*helm-flake8-errors*")))))

                                        ; generate a emacs lisp function that given an output line of flake8 command open the file in the output at the line numbe and column 

                                        ;Here's an example function that you can use:
                                        ;
                                        ;```emacs-lisp
(defun my-pymacs-exec-region ()
  "Execute the selected region using Pymacs."
  (interactive)
  (let ((region (buffer-substring-no-properties (region-beginning) (region-end))))
    (pymacs-exec "python" region)))
                                        ;```
                                        ;
                                        ;This function first captures the selected region of text using `buffer-substring-no-properties`, and then passes it to `pymacs-exec` using the language parameter `"python"`. 
                                        ;
                                        ;You can bind this function to any keybind you like, such as `C-c p e`:
                                        ;
                                        ;```emacs-lisp
;; Bind the function to a key
(global-set-key (kbd "C-c p e") 'my-pymacs-exec-region)
                                        ;```
                                        ;
                                        ;Now, when you have some Python code selected, just press `C-c p e` to execute it using Pymacs!

                                        ;Here is the Emacs Lisp function that you can use to call the `pymacs-eval` function with the selected text and replace the region with the result:
                                        ;
                                        ;```
(defun eval-with-pymacs ()
  "Call `pymacs-eval' with the selected region and replace the region with the result."
  (interactive)
  (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
    (if (equal "" input)
        (message "Empty selection.")
      (let* ((output (pymacs-eval input))
             (start (region-beginning))
             (end (region-end)))
        (delete-region start end)
        (goto-char start)
        (insert output)))))
                                        ;```
                                        ;
                                        ;To use this function, you can copy and paste it in your `init.el` or `~/.emacs` file, and then bind it to a key combination of your choice:
                                        ;
                                        ;```
(global-set-key (kbd "C-c e") 'eval-with-pymacs)
                                        ;```
                                        ;
                                        ;This will bind the `eval-with-pymacs` function to the `C-c e` key combination. Whenever you want to evaluate some Python code with Pymacs, simply select the code in your Emacs buffer, press `C-c e`, and the selected text will be replaced with the result of the evaluation.
                                        ;Here is an Emacs function that converts a Python dictionary defined using a dict call with a Python dictionary literal with the same values:

(defun convert-dict-to-literal ()
  "Convert a Python dictionary defined using a dict call into a dictionary literal with the same values."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (when (looking-at "dict(.*{")
      (let ((start (match-beginning 0))
            (end (progn (forward-list) (1- (point)))))
        (goto-char start)
        (delete-char 4)
        (search-forward-regexp "({[^}]+})")
        (let ((d (read (match-string 1))))
          (delete-region start end)
          (goto-char start)
          (insert (format "%S" d))))))) 

                                        ;This function first checks if the cursor is positioned at the beginning of a line with a dict call, and if so, finds the region of the dictionary that is defined using a dictionary literal. It then reads the dictionary values into Emacs Lisp and replaces the entire region with a formatted string representation of the literal values. The resulting region will now contain the same dictionary defined using a dictionary literal instead of a dict call.

                                        ; write a python function to convert code with dicts to dict as literal
                                        ;"""
                                        ;template_context = dict(
                                        ;            recipient=email,
                                        ;            first_name=self.request.user.profile.first_name,
                                        ;            last_name=self.request.user.profile.last_name or "",
                                        ;            app_key=self.app_key,
                                        ;            link=serializer.data["share_guid_url"],
                                        ;            title="Invitation to join %s" % self.app_key,
                                        ;            project="Contextual",
                                        ;        )
                                        ;"""
                                        ;template_context = {
                                        ;            "recipient": email,
                                        ;            "first_name": self.request.user.profile.first_name,
                                        ;            "last_name": self.request.user.profile.last_name or "",
                                        ;            "app_key": self.app_key,
                                        ;            "link": serializer.data["share_guid_url"],
                                        ;            "title": "Invitation to join %s" % self.app_key,
                                        ;            "project": "Contextual"
                                        ;}

                                        ; in the function change the working directory to the first '.ropeproject' in the path
(require 'helm)
(require 'helm-utils)

(defun helm-flake8-default ()
  "Run flake8 and create a helm source from the output."
  (interactive)
  (let ((output (shell-command-to-string "flake8  --max-line-length=80")))
    (helm :sources
          `((name . "Flake8")
            (candidates . ,(split-string output "\n"))
            (action . (("Jump to file" . (lambda (candidate)
                                           (open-file-at-error candidate)))))))))
(defun helm-flake8 ()
  "Run flake8 and create a helm source from the output."
  (interactive)
  (let* ((current-dir default-directory)
         (ropeproject-dir (locate-dominating-file current-dir ".ropeproject")))
    (when ropeproject-dir
      (cd ropeproject-dir)))
  (let ((output (shell-command-to-string "flake8  --max-line-length=80")))
    (helm :sources
          `((name . "Flake8")
            (candidates . ,(split-string output "\n"))
            (action . (("Jump to file" . (lambda (candidate)
                                           (open-file-at-error candidate)))))))))
(defun helm-pre-commit-flake8 ()
  "Run flake8 and create a helm source from the output."
  (interactive)
  (let* ((current-dir default-directory)
         (ropeproject-dir (locate-dominating-file current-dir ".ropeproject")))
    (when ropeproject-dir
      (cd ropeproject-dir)))
  (let ((output (shell-command-to-string "pre-commit run flake8")))
    (helm :sources
          `((name . "Flake8")
            (candidates . ,(seq-filter (lambda (line) (string-match "^\\([^:]+\\):" line)) (split-string output "\n")))
            (action . (("Jump to file" . (lambda (candidate)
                                           (open-file-at-error candidate)))))))))
(defun open-file-at-error (line)
  "Open file at error location in flake8 output."
  (let* ((parts (split-string line ":" t))
         (file-name (car parts))
         (line-number (string-to-number (cadr parts)))
         (column-number (string-to-number (caddr parts))))
    (message (concat "./" file-name))
    (find-file (concat "./" file-name))
    (goto-line line-number)
    (move-to-column column-number)))

(setq lsp-diagnostics-provider :auto)

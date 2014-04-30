;; PSVN ================================================================================
(require 'psvn)
(setq svn-status-hide-unknown t)
(setq svn-status-hide-unmodified t)
;;(add-hook 'svn-status-mode-hook 
;;          #'(lambda ()
;;              (evil-mode 0)
;;              )
;;          )
(defun svn-add nil
  (interactive)
  (insert (buffer-file-name (nth 1 (buffer-list)))))

(defalias 'svn-log 'svn-status-show-svn-log)
;;(defun 'svn-ediff)
(defun my-vc-dir-hide-some (states)
  "Hide files whose state is in STATES."
  (interactive
   (list
    (progn
      (unless vc-ewoc
        (error "Not in a vc-dir buffer"))
      (mapcar 'intern
              (completing-read-multiple
               "Hide files that are in state(s): "
               (let (possible-states)
                 (ewoc-map (lambda (item)
                             (let ((state (vc-dir-fileinfo->state item)))
                               (when state
                                 (pushnew state possible-states))
                               nil))
                           vc-ewoc)
                 (mapcar 'symbol-name possible-states))
               nil t)))))
  (let ((inhibit-read-only t))
    (ewoc-filter vc-ewoc
                 (lambda (file)
                   (not (memq (vc-dir-fileinfo->state file) states))))))
(eval-after-load "vc-dir"
    '(define-key vc-dir-mode-map "H" 'my-vc-dir-hide-some))

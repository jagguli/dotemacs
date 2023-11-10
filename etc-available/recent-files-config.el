
;;Recent Files===========================================================================
(req-package recentf
  :config
  (setq
    recentf-exclude '("~$")
    recentf-max-saved-items 99
    ; These are directories to exclude from the recentf list:
    ; - ~/.cache/
    ; - ~/.*cache/
    ; - ~/.local/share/Trash/
    ; If the recentf-exclude list already exists, we append these directories to it.
    recentf-exclude 
        (append '("\\`\\(/home/[^/]+\\)?/\\.cache/.*" 
                    "\\`\\(/home/[^/]+\\)?/\\..*cache/.*" 
                    "\\`\\(/home/[^/]+\\)?/.local/share/Trash/.*") 
    recentf-exclude))
  :init
  (progn
(global-set-key "\C-x\C-r" 'helm-recentf)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Here I override some functions of recentf to get a merged list
  ;; This seems to be stable (used it for approx two weeks at the time 
  ;; of this writing)
  (defun recentf-save-list ()
    "Save the recent list.
Load the list from the file specified by `recentf-save-file',
merge the changes of your current session, and save it back to the
file."
    (interactive)
    (let ((instance-list (copy-list recentf-list)))
      (recentf-load-list)
      (recentf-merge-with-default-list instance-list)
      (recentf-write-list-to-file)))

  (defun recentf-merge-with-default-list (other-list)
    "Add all items from `other-list' to `recentf-list'."
    (dolist (oitem other-list)
      ;; add-to-list already checks for equal'ity
      (add-to-list 'recentf-list oitem)))

  (defun recentf-write-list-to-file ()
    "Write the recent files list to file.
Uses `recentf-list' as the list and `recentf-save-file' as the
file to write to."
    (condition-case error
        (with-temp-buffer
          (erase-buffer)
          (set-buffer-file-coding-system recentf-save-file-coding-system)
          (insert (format recentf-save-file-header (current-time-string)))
          (recentf-dump-variable 'recentf-list recentf-max-saved-items)
          (recentf-dump-variable 'recentf-filter-changer-current)
          (insert "\n \n;;; Local Variables:\n"
                  (format ";;; coding: %s\n" recentf-save-file-coding-system)
                  ";;; End:\n")
          (write-file (expand-file-name recentf-save-file))
          (when recentf-save-file-modes
            (set-file-modes recentf-save-file recentf-save-file-modes))
          nil)
      (error
       (warn "recentf mode: %s" (error-message-string error)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (recentf-mode 1))
  )

  
;(global-set-key "\C-x\C-r" 'recentf-open-files)

;; Save the recentf file list every 10 minutes (= 600 seconds)
;;(setq recentf-last-list '())
;(defun recentf-save-if-changes ()
;  "Test if the recentf-list has changed and saves it in this case"
;  (unless (equalp recentf-last-list recentf-list)
;    (setq recentf-last-list recentf-list)
;    (recentf-save-list)))
;(run-at-time t 600 'recentf-save-if-changes)


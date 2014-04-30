(defun diff-version-old (version)
  "Diff file in two xplan versions"
  (interactive "nVersion: \n")
  (ediff buffer-file-name
         (replace-regexp-in-string
          "xplan[0-9]*/"
          (format "%s%s/" "xplan"
                  (if (equal version 0) "" version))
          buffer-file-name)))


(defun diff-version (version)
  "Diff selected region in two xplan versions"
  (interactive "nVersion: \n")
  (ediff-regions-linewise (current-buffer)
         (find-file (replace-regexp-in-string
          "xplan[0-9]*/"
          (format "%s%s/" "xplan"
                  (if (equal version 0) "" version))
          buffer-file-name))))


(defun switch-version (version)
  "Switch to file in other xplan version"
  (interactive "nVersion: \n")
  (goto-line  (line-number-at-pos)
              (find-file (replace-regexp-in-string
                          "/xplan[0-9]*/"
                          (format "/%s%s/" "xplan"
                                  (if (equal version 0) "" version))
                          buffer-file-name))))

(defun diff-version (version)
  (interactive "nVersion: \n")
  ;;(print (format "%s%s" "xplan" (if (equal version 0) "" version))))
  (ediff buffer-file-name (replace-regexp-in-string "xplan[0-9]*/" (format "%s%s/" "xplan" (if (equal version 0) "" version)) buffer-file-name)))

(defun switch-version (version)
  (interactive "nVersion: \n")
  (goto-line  (line-number-at-pos) (find-file (replace-regexp-in-string "/xplan[0-9]*/" (format "/%s%s/" "xplan" (if (equal version 0) "" version)) buffer-file-name))))

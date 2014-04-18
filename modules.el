(defconst user-modules-dir
  (file-name-as-directory (concat (file-name-as-directory (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/"))) "modules")))
(defconst user-lib-dir
  (file-name-as-directory (concat user-modules-dir "lib")))

(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file (file-name-as-directory (concat user-modules-dir "etc")))))

(defun add-user-lib (p)
  "Adds the path (specified relative to the the pack's lib dir)
  to the load-path"
  (add-to-list 'load-path (concat user-lib-dir p)))

(setq custom-theme-directory user-lib-dir)
(add-to-list 'load-path user-lib-dir)
;;(load-theme 'tango-2-steven t)
(load-file (concat user-modules-dir "init.el"))

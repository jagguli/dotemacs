;;(require 'emamux)
;;(print (format "tmux rename-window %s" (car (last (split-string server-name "/")))))
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (modify-frame-parameters 
             frame `((prevname . ,(shell-command-to-string "tmux display-message -p \"#W\""))))
            (shell-command
             (format "tmux rename-window %s"
                     (car (last (split-string server-name "/")))))) t)

(add-hook 'delete-frame-functions
          (lambda (frame) 
            (print "deleting frame")
            (shell-command
             (format "tmux rename-window '%s'" (frame-parameter frame 'prevname)))))

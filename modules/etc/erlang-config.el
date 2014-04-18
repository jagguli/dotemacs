;;(setq load-path (cons  "/usr/local/otp/lib/tools-<ToolsVer>/emacs" load-path))
;;(setq erlang-root-dir "/usr/local/otp")
;;(setq exec-path (cons "/usr/local/otp/bin" exec-path))
;;(require 'erlang-start)
;;(require 'erlang-flymake)


(setq auto-mode-alist
      (append
       '(("\\.app$" . erlang-mode)
         ("\\.erl$" . erlang-mode)
         ("\\.config$" . erlang-mode))
              auto-mode-alist))

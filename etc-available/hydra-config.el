;;http://oremacs.com/2015/01/20/introducing-hydra/
(req-package hydra
  :require
  (major-mode-hydra)
  :bind
  ("C-M-m" . major-mode-hydra)
  :init
  (progn

    (defhydra hydra-magit (:color blue :columns 8)
      "Magit"
      ("c" magit-status "status")
      ("C" magit-checkout "checkout")
      ("v" magit-branch-manager "branch manager")
      ("m" magit-merge "merge")
      ("l" magit-log "log")
      ("!" magit-git-command "command")
      ("$" magit-process "process"))
    (global-set-key (kbd "C-c g") 'hydra-magit/body)
    )
  )

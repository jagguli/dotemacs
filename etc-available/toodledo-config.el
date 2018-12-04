(req-package org-toodledo
  :loadpath (concat user-lib-dir "toodledo")
  :require (password-store org-indent)
  :config
  (setq
     org-toodledo-userid (password-store-get "internet/toodledo/userid")
     org-toodledo-password (password-store-get "internet/toodledo/password")
     org-toodledo-userid (password-store-get "internet/toodledo/userid")
     org-toodledo-password (password-store-get "internet/toodledo/password")
     org-toodledo-folder-support-mode t
     org-toodledo-folder-support-mode (quote heading)
  )
)

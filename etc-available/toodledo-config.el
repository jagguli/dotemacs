(req-package org-toodledo
  :require (password-store)
  :config
  (setq
     org-toodledo-userid (password-store-get "internet/toodledo/userid")
     org-toodledo-password (password-store-get "internet/toodledo/password")
  )
)

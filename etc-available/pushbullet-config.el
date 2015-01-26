(req-package pushbullet
  :require (password-store)
  :init
  (progn

    (defadvice pushbullet (after pushbullet-init (start end title) activate)
      (setq pushbullet-api-key (password-store-get "internet/pushbullet")))
    )
  )

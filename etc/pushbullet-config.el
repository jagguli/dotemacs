(add-user-lib "revolver")
(require 'pushbullet)
(require 'password-store)
(setq pushbullet-api-key (password-store-get "internet/pushbullet"))

(add-user-lib "revolver")
(require 'pushbullet)
(require 'password-store)

(defadvice pushbullet (after pushbullet-init (arg char) activate)
  (setq pushbullet-api-key (password-store-get "internet/pushbullet")))

(req-package slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config
  (slack-register-team
   :name "streethawk"
   :default t
   :client-id "2189686668.48286817107"
   :client-secret "9839b7d0cb11c19f9e647b7e6eda0d5a"
   :token "xoxp-2189686668-19803167138-40995974385-c58743c259"
   :subscribed-channels '(general devops))

  ;;(slack-register-team
  ;; :name "test"
  ;; :client-id "3333333333.77777777777"
  ;; :client-secret "cccccccccccccccccccccccccccccccc"
  ;; :token "xxxx-yyyyyyyyyy-zzzzzzzzzzz-hhhhhhhhhhh-llllllllll"
  ;; :subscribed-channels '(hoge fuga))

  (evil-define-key 'normal slack-info-mode-map
    ",u" 'slack-room-update-messages)
  (evil-define-key 'normal slack-mode-map
    ",c" 'slack-buffer-kill
    ",ra" 'slack-message-add-reaction
    ",rr" 'slack-message-remove-reaction
    ",rs" 'slack-message-show-reaction-users
    ",pl" 'slack-room-pins-list
    ",pa" 'slack-message-pins-add
    ",pr" 'slack-message-pins-remove
    ",mm" 'slack-message-write-another-buffer
    ",me" 'slack-message-edit
    ",md" 'slack-message-delete
    ",u" 'slack-room-update-messages
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel
    "\C-n" 'slack-buffer-goto-next-message
    "\C-p" 'slack-buffer-goto-prev-message)
   (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",s" 'slack-message-send-from-buffer
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel))

(use-package alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier))
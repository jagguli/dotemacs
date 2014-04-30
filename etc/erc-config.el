(setq erc-hide-list '("JOIN" "PART" "QUIT"))
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#emacs" "#python" "#archlinux" )
        (".*\\.oftc.net" "#suckless")))

(defun erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?
      (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :full-name "Steven J" :nick "jagguli" )
            (erc :server "irc.oftc.net" :port 6667 :nick "jagguli" :full-name "Steven J"))))

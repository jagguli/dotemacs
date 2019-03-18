;;http://oremacs.com/2015/01/20/introducing-hydra/
(req-package hydra
  :require
  (major-mode-hydra)
  :bind
  ("C-M-m" . major-mode-hydra)
  :init
  (progn
    (defhydra hydra-projectile-other-window (:color teal)
      "projectile-other-window"
      ("f"  projectile-find-file-other-window        "file")
      ("g"  projectile-find-file-dwim-other-window   "file dwim")
      ("d"  projectile-find-dir-other-window         "dir")
      ("b"  projectile-switch-to-buffer-other-window "buffer")
      ("q"  nil                                      "cancel" :color blue))

    (defhydra hydra-projectile (:color teal
                                       :hint nil)
      "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
 _fd_: file curr dir   _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
  _r_: recent file                                               ^^^^_z_: cache current
  _d_: dir

"
      ("a"   projectile-ag)
      ("b"   projectile-switch-to-buffer)
      ("c"   projectile-invalidate-cache)
      ("d"   projectile-find-dir)
      ("s-f" projectile-find-file)
      ("ff"  projectile-find-file-dwim)
      ("fd"  projectile-find-file-in-directory)
      ("g"   ggtags-update-tags)
      ("s-g" ggtags-update-tags)
      ("i"   projectile-ibuffer)
      ("K"   projectile-kill-buffers)
      ("s-k" projectile-kill-buffers)
      ("m"   projectile-multi-occur)
      ("o"   projectile-multi-occur)
      ("s-p" projectile-switch-project "switch project")
      ("p"   projectile-switch-project)
      ("s"   projectile-switch-project)
      ("r"   projectile-recentf)
      ("x"   projectile-remove-known-project)
      ("X"   projectile-cleanup-known-projects)
      ("z"   projectile-cache-current-file)
      ("`"   hydra-projectile-other-window/body "other window")
      ("q"   nil "cancel" :color blue))

    (defhydra hydra-global-org (:color blue)
      "Org"
      ("s" org-timer-start "Start Timer")
      ("S" org-timer-stop "Stop Timer")
      ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
      ("p" org-timer "Print Timer") ; output timer value to buffer
      ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
      ("o" org-clock-out "Clock-Out") ; you might also want (setq org-log-note-clock-out t)
      ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
      ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
      ("i" org-journal-new-entry "iJournal entry")
      ("t" org-todo-list "List todos"))
      ("l" org-capture-goto-last-stored "Last Capture"))
    (global-set-key (kbd "<f3>") 'hydra-global-org/body)
    (global-set-key (kbd "C-c p") 'hydra-projectile/body)
    )
  )

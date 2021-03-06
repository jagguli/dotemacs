;;http://www.emacswiki.org/emacs/SettingFrameColorsForEmacsClient
;;;
;; Using emacs --daemon and emacsclient I have often had cause to use emacs at the terminal, 
;; but I like to have a colour scheme in my graphical frames that is unreadable in the console. 
;; This code lives in my .emacs file and allows me to setup color and font settings for 
;; graphical frames, but leave the console frames to use the default colour scheme.  
;; I've found this very useful.  Tested with Emacs 24.0.50.1 @ 2010-20-07 -- Geoff Teale

(defun setup-window-system-frame-colours (&rest frame)
  (print "setup-window-system-frame-colours")
  (if window-system
      (let ((f (if (car frame)
		   (car frame)
		 (selected-frame))))
	(progn
	  (set-face-background 'default "black" f)
	  (set-face-foreground 'default "#FFFFFF" f)
	  (set-face-background 'fringe  "#000000" f)
	  (set-face-background 'cursor "#2F4F4F" f)
	  (set-face-background 'mode-line "#2F4F4F" f)
	  (set-face-foreground 'mode-line "#BCBf91" f)))))

(require 'server)
(defadvice server-create-window-system-frame
  (after set-window-system-frame-colours ())
  "Set custom frame colours when creating the first frame on a display"
  (print "Running after frame-initialize")
  (setup-window-system-frame-colours))
(ad-activate 'server-create-window-system-frame)
(add-hook 'after-make-frame-functions 'setup-window-system-frame-colours t)

;;; mmm-xplan.el --- MMM submode class for Xplan Templates
;;;

;; Copyright (C) 2014-2015 by Steven Joseph

;; Author: Philip Jenvey <pjenvey@underboss.org>
;; URL: https://bitbucket.org/pjenvey/mmm-xplan
;; Version: 1.1
;; Package-Requires: ((mmm-mode "0.4.8"))

;;{{{ GPL

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;}}}

;;; Commentary:

;; Parts of this code was borrowed from mmm-mako mode. (Thanks Philip Jenvey)
;; Parts of this code was borrowed from mmm-myghty mode. (Thanks Ben
;; Bangert and Michael Abraham Shulman)

;; Bugs -
;; mmm classes with :back delimeters of "$" (such as Xplan's ## and %)
;; will carry the :back match over to the next line when <return> is
;; used to end the line (probably because the original "$" marker is
;; moved to the next line and mmm-mode doesn't automatically update
;; the match).

;;; Code:

(require 'mmm-auto)
(require 'mmm-compat)
(require 'mmm-vars)

;;{{{ Xplan Tags

(defvar mmm-xplan-block-tags
  '("page" "include" "def" "namespace" "inherit" "call" "doc" "text"
    "!"))

(defvar mmm-xplan-block-tags-regexp
  (mmm-regexp-opt mmm-xplan-block-tags t)
  "Matches any Xplan tag name after the \"<:\".")

(defun mmm-xplan-verify-python-block ()
  (save-match-data
    (not (looking-at mmm-xplan-block-tags-regexp))))

;;}}}
;;{{{ Add Classes

(mmm-add-group
 'xplan
 `((xplan-text
    :submode text-mode
    :face mmm-output-submode-face
    :front "<%text>"
    :back "</%text>"
    :insert ((?t xplan-<%text> nil @ "<%text>" @ "\n" _ "\n" @
                 "</%text>" @)))
   (xplan-doc
    :submode text-mode
    :face mmm-comment-submode-face
    :front "<%doc>"
    :back "</%doc>"
    :insert ((?o xplan-<%doc> nil @ "<%doc>" @ "\n" _ "\n" @ "</%doc>"
                 @)))
   (xplan-one-line-comment
    :submode text-mode
    :face mmm-comment-submode-face
    :front "^[ \t]*##"
    :back "\n"
    :front-delim 0
    :insert ((?# xplan-comment nil @ "##" @ " " _ @
                 '(mmm-xplan-end-line) "\n" @)))
   (xplan-init
    :submode python-mode
    :face mmm-init-submode-face
    :front "<:py"
    :back ":>"
    :insert ((?! xplan-<%!-%> nil @ "<:py" @ "\n" _ "\n" @ ":>" @)))
   (xplan-python
    :submode python-mode
    :face mmm-code-submode-face
    :front "<:py"
    :front-verify mmm-xplan-verify-python-block
    :back ":>"
    :insert ((?% xplan-<%-%> nil @ "<:py" @ "\n" _ "\n" @ ":>" @)))
   (xplan-python-expression
    :submode python-mode
    :face mmm-output-submode-face
    :front "<:="
    :back ":>"
    :insert ((?$ xplan-<:=-:> nil @ "<:=" @ _ @ ":>" @)))
   (xplan-control
    :submode python-mode
    :face mmm-code-submode-face
    :front "^[ \t]*%[^>]"
    :back "$"
    :insert ((tab xplan-%-line nil @ "%" @ " " _ @
                  '(mmm-xplan-end-line) "\n" @)))
   (xplan-def
    :submode python-mode
    :face mmm-declaration-submode-face
    :front "<%def[ \t]+name=\\([\"']\\)"
    :save-matches 1
    :back "~1[ \t]*>"
    :insert ((?d xplan-<%def> nil @ "<%def name=\"" @ _ "()" @ "\">" @
                 "\n</%def>")))
   (xplan-call
    :submode python-mode
    :face mmm-output-submode-face
    :front "<%call[ \t]+expr=\\([\"']\\)"
    :save-matches 1
    :back "~1[ \t]*>"
    :insert ((?c xplan-<%call> nil @ "<%call expr=\"" @ _ "()" @ "\">"
                 @ "\n</%call>")))
   (xplan-page
    :submode python-mode
    :face mmm-declaration-submode-face
    :front "<%page[ \t]+"
    :back "/>"
    :insert ((?p xplan-<%page> nil @ "<%page " @ _ @ "/>" @)))
   (xplan-include
    :submode text-mode
    :face mmm-output-submode-face
    :front "<%include[ \t]+file=\\([\"']\\)"
    :save-matches 1
    :back "~1[ \t]*/>"
    :insert ((?u xplan-<%include> nil @ "<%include file=\"" @ _ @
                 "\"/>" @)))
   (xplan-namespace
    :submode text-mode
    :face mmm-special-submode-face
    :front "<%namespace[ \t]+"
    :back "[ \t]*/>"
    :insert ((?n xplan-<%namespace> nil @ "<%namespace " @ _ @ "/>"
                 @)))
   (xplan-inherit
    :submode text-mode
    :face mmm-init-submode-face
    :front "<%inherit[ \t]+file=\\([\"']\\)"
    :save-matches 1
    :back "~1[ \t]*/>"
    :insert ((?i xplan-<%inherit> nil @ "<%inherit file=\"" @ _ @
                 "\"/>" @)))))

;;}}}
;;{{{ One-line Sections

(defun mmm-xplan-start-line ()
  (if (bolp)
      ""
    "\n"))

(defun mmm-xplan-end-line ()
  (if (eolp)
      (delete-char 1)))

;;}}}
;;{{{ Set Mode Line

(defun mmm-xplan-set-mode-line ()
  (setq mmm-buffer-mode-display-name "Xplan"))
(add-hook 'mmm-xplan-class-hook 'mmm-xplan-set-mode-line)

;;}}}

(provide 'mmm-xplan)

;;; mmm-xplan.el ends here

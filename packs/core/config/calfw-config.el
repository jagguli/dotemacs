(require 'calfw)
(require 'calfw-gcal)
(require 'calfw-ical)

(add-hook 'after-init-hook
          (lambda ()
            (cfw:open-ical-calendar "https://www.google.com/calendar/ical/../basic.ics")
            (delete-other-windows)))

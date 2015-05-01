(req-package calfw
  :require (
            calfw-org
            calfw-ical
            calfw-cal
            )
  :init
  (progn
    (setq cfw:ical-url-to-buffer-get 'cfw:ical-url-to-buffer-external)
    (defun my-open-calendar ()
      (interactive)
      (cfw:open-calendar-buffer
       :contents-sources
       (list
        ;;(cfw:org-create-source "Green")  ; orgmode source
        ;;(cfw:howm-create-source "Blue")  ; howm source
        ;;(cfw:cal-create-source "Orange") ; diary source
        (cfw:ical-create-source "gcal" "https://www.google.com/calendar/ical/melit.stevenjoseph%40gmail.com/private-a2f882502d3036da932b20263cf1a618/basic.ics" "IndianRed") ; google calendar ICS
        (cfw:ical-create-source "canada" "https://www.google.com/calendar/ical/7nnua78g9rr04eu4a3581c0oc0%40group.calendar.google.com/private-71c51bc451b4931a368b9c3652d9d9a1/basic.ics" "BrightBlue")
        ;;(cfw:ical-create-source "Moon" "~/moon.ics" "Gray")  ; ICS source1
        )
       )
      ) 
    )
  )

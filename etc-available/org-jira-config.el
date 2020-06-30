(req-package org-jira
  :config
  (setq
   jiralib-url "https://streethawk.atlassian.net"
   org-jira-custom-jqls
  '(
    (:jql "assignee in (currentUser()) AND sprint in (openSprints()) ORDER BY Rank ASC "
          :limit 50
          :filename "my-current-sprint")
    )
   )
  :init
  (progn
    )
)

(req-package org
  :require (
    ox-publish
    )
  :config (setq
    org-publish-project-alist
      '(("posts"
         :base-directory "~/org/blog/"
         :base-extension "org"
         :publishing-directory "~/org/public/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-sitemap t)
        ("org-static"
         :base-directory "~/org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/org/public/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("all" :components ("posts")))
    )
  )

(use-package org-html-themify
  :straight
  (org-html-themify
   :type git
   :host github
   :repo "DogLooksGood/org-html-themify"
   :files ("*.el" "*.js" "*.css"))
  :hook (org-mode . org-html-themify-mode)
  :custom
  (org-html-themify-themes
   '((dark . modus-vivendi)
     (light . modus-operandi))))

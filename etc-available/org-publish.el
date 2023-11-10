(defun org-sitemap-date-entry-format (entry style project)
  "Format ENTRY in org-publish PROJECT Sitemap format ENTRY ENTRY STYLE format that includes date."
  (let ((filename (org-publish-find-title entry project)))
    (if (= (length filename) 0)
        (format "*%s*" entry)
      (format "{{{timestamp(%s)}}} [[file:%s][%s]]"
              (format-time-string "%Y-%m-%d"
                                  (org-publish-find-date entry project))
              entry
              filename))))

(defvar asyncmind-website-html-head
  "
<link rel='stylesheet' href='assets/css/minimal.css' type='text/css'/>

<link rel='apple-touch-icon' href='icon.png'>
<script src='assets/js/vendor/modernizr-3.11.2.min.js'></script>
<script src='assets/js/plugins.js'></script>
<script src='https://unpkg.com/@aeternity/aepp-sdk/dist/aepp-sdk.browser-script.js'></script>
<script type='module' src='assets/js/main.js'></script>
")

(defvar asyncmind-website-html-blog-head
"")

(defvar asyncmind-website-html-preamble
  "<div class='nav'>
<ul>
</ul>
<button id='login_button'>Wallet Disconnected.</button>
</div>")

(defvar asyncmind-website-html-postamble
  "<div class='footer'>
Copyright 2023 %a (%v HTML).<br>
Last updated %C. <br>
Built with %c.
</div>")

(req-package org
  :config (setq
    org-publish-project-alist
      `(("posts"
         :base-directory "~/Org/blog/"
         :base-extension "org"
         :publishing-directory "/var/www/stevenjoseph.in/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-preamble t
         :auto-sitemap nil
         :auto-index nil
         :sitemap-title "Steven's Blog"
         :sitemap-filename "sitemap.org"
         :sitemap-sort-files anti-chronologically
         ;:makeindex t
         ;:sitemap-format-entry org-sitemap-date-entry-format
         ;:section-numbers nil
         ;:with-toc nil
         :html-head ,asyncmind-website-html-head
         ;:html-preamble ,asyncmind-website-html-preamble
         :html-postamble ,asyncmind-website-html-postamble
         ;:sitemap-file-entry-format "%d - %t"
         )
        ("posts-staging"
         :base-directory "~/Org/blog/"
         :base-extension "org"
         :publishing-directory "/var/www/staging.stevenjoseph.in/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-preamble t
         :auto-sitemap nil
         :auto-index nil
         :sitemap-title "Steven's Blog"
         :sitemap-filename "sitemap.org"
         :sitemap-sort-files anti-chronologically
         ;:makeindex t
         ;:sitemap-format-entry org-sitemap-date-entry-format
         ;:section-numbers nil
         ;:with-toc nil
         :html-head ,asyncmind-website-html-head
         ;:html-preamble ,asyncmind-website-html-preamble
         :html-postamble ,asyncmind-website-html-postamble
         ;:sitemap-file-entry-format "%d - %t"
         )
        ("damagebdd"
         :base-directory "~/Org/damagebdd/"
         :base-extension "org"
         :publishing-directory "/var/www/damagebdd/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-preamble t
         :auto-sitemap nil
         :auto-index nil
         :sitemap-title "DamageBDD - BDD at scale."
         :sitemap-filename "sitemap.org"
         :sitemap-sort-files anti-chronologically
         ;:makeindex t
         ;:sitemap-format-entry org-sitemap-date-entry-format
         ;:section-numbers nil
         :with-toc nil
         :html-head ,asyncmind-website-html-head
         ;:html-preamble ,asyncmind-website-html-preamble
         :html-postamble ,asyncmind-website-html-postamble
         ;:sitemap-file-entry-format "%d - %t"
         )
        ;("my-blog"
        ; :base-directory "~/my-blog/org-files/"
        ; :base-extension "org"
        ; :publishing-directory "~/my-blog/html-files/"
        ; :recursive t
        ; :publishing-function org-html-publish-to-html
        ; :headline-levels 4
        ; :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"custom-style.css\" />"
        ; :auto-preamble t
        ; :auto-sitemap t
        ; :sitemap-filename "index.org"
        ; :sitemap-title "My Blog Index"
        ; :sitemap-sort-files anti-chronologically
        ; :sitemap-file-entry-format "%d - %t"
        ;)
        ("org-static-blog"
         :base-directory "~/Org/blog/assets/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|ttf\\|map"
         :publishing-directory "/var/www/stevenjoseph.in/assets/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("org-static-blog-staging"
         :base-directory "~/Org/blog/assets/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|ttf\\|map"
         :publishing-directory "/var/www/staging.stevenjoseph.in/assets/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("org-static-damagebdd"
         :base-directory "~/Org/damagebdd/assets/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|ttf\\|map"
         :publishing-directory "/var/www/damagebdd/assets/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("all" :components ("posts" "org-static-blog" "damagebdd" "org-static-damagebdd")))
      org-export-global-macros
      '(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@"))
      org-export-with-toc nil
      )
  )




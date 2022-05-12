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
"<link href='http://fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic' rel='stylesheet' type='text/css'>
<link rel='stylesheet' href='css/site.css' type='text/css'/>
<link rel='manifest' href='site.webmanifest'>
<link rel='apple-touch-icon' href='icon.png'>
<link rel='stylesheet' type='text/css' href='./css/main.css' />
<link rel='stylesheet' type='text/css' href='./css/normalize.css' />
<link rel='stylesheet' type='text/css' href='./css/sakura.css' />
<script src='js/vendor/modernizr-3.11.2.min.js'></script>
<script src='js/plugins.js'></script>
<script src='js/main.js'></script>
<meta name='theme-color' content='#fafafa'>")

(defvar asyncmind-website-html-blog-head
"<link href='http://fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic' rel='stylesheet' type='text/css'>
<link rel='stylesheet' href='../css/site.css' type='text/css'/>")

(defvar asyncmind-website-html-preamble 
  "<div class='nav'>
<ul>
<li><a href='index.html'>Home</a></li>
<li><a href='http://github.com/jagguli'>GitHub</a></li>
<li><a href='http://twitter.com/asyncmind'>Twitter</a></li>
</ul>
</div>")

(defvar asyncmind-website-html-postamble 
  "<div class='footer'>
Copyright 2013 %a (%v HTML).<br>
Last updated %C. <br>
Built with %c.
</div>")

(req-package org
  :config (setq
    org-publish-project-alist
      `(("posts"
         :base-directory "~/org/blog/"
         :base-extension "org"
         :publishing-directory "~/org/public_html/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-sitemap t
         :sitemap-title "Asyncmind Index"
        :sitemap-filename "index.org"
        :sitemap-sort-files anti-chronologically
        :sitemap-format-entry org-sitemap-date-entry-format
         :section-numbers nil
         :with-toc nil
         :html-head ,asyncmind-website-html-head
         :html-preamble ,asyncmind-website-html-preamble
         :html-postamble ,asyncmind-website-html-postamble
         )
        ("org-static"
         :base-directory "~/org/blog/static/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/org/public_html/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("all" :components ("posts" "org-static")))
      org-export-global-macros
      '(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@"))
    )
  )




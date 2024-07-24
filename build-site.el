;; > ---------------------------------------- >
;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)
;; < ---------------------------------------- <


;; Load the publishing  system
;; > Quand on parle de publier, on parle surtout 
(require 'ox-publish)


;; Customize the HTML output
(setq org-html-validation-link nil                ;; Don't show validation link
      org-html-head-include-scripts nil           ;; Use our own scripts
      org-html-head-include-default-style nil     ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"./css/simple.css\" />")  ;; Où trouver le fichier CSS




;(org-publish-find-date "documentation.org" (list "content"))


(defun my-sitemap-func (title list) ; (ref:pank.eu-blog-index)
  (mapconcat
   'identity
   (list
    (concat "#+TITLE: " title)
    (org-list-to-subtree list nil '(:istart "   + "))
    )
   "\n\n"))



;; Define the publishing project
;; > C'est en fait une liste de configuration pour différents projets.
;;   Par exemple, on exporte juste la config de "org-blog" ici.
;; > C-h v sur la fonction pour avoir plus d'info (tab pour voir les variables).
(setq org-publish-project-alist
      (list
       (list "org-blog"
	     :recursive t
	     :base-directory "./content"
	     :publishing-directory "./public"
	     :base-extension "org"
	     :publishing-function 'org-html-publish-to-html
	     :with-author t              ;; don't include author name
	     :with-creator t             ;; include Emacs and Org version in footer
	     :with-toc nil               ;; include table of contents
	     :section-numbers nil        ;; don't include section numbers
	     :time-stamp-file t        ;; don't include time stamp in file
	     ;; Publication index/site-map
	     :auto-sitemap t
	     :sitemap-filename "index.org"
	     :sitemap-title "Index du blogue"
	     :sitemap-style 'list
	     :sitemap-function 'my-sitemap-func
	     :author "Charles-Édouard Lizotte"
	     :email "charlesedouardlizotte@protonmail.com"
;	     :sitemap-format-entry "%d - %t"
	     )
;
      ; On publie les fichier CSS en css dans ./public/css
      (list "org-css"
            :base-directory "css/"
            :base-extension "css"
            :publishing-directory "public/css"
            :recursive t
            :publishing-function 'org-publish-attachment
            )));


;; Generate the site output
(org-publish-all t)

(message "Build complete!")

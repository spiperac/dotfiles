;;; website --- Build Personal Website from Org files
;;; Commentary:
;; Configuration file containing tools to build a personal website.

;;; Code:

;; Loading publishing system
(require 'ox)

(use-package htmlize
  :defer t)

(defun copy-theme-assets ()
  "Copy theme assets to publish directory."
  (let ((src-dir "~/Vault/Web/spiperac.dev/theme/")
        (dest-dir "~/Vault/Web/spiperac.dev/public/"))
    ;; Create assets directory if it doesn't exist
    (make-directory (concat dest-dir "assets/") t)
    ;; Copy CSS
    (copy-file (concat src-dir "style.css")
               (concat dest-dir "style.css")
               t)
    ;; Copy assets directory
    (dolist (file (directory-files-recursively (concat src-dir "assets/") ".*"))
      (let* ((relative-path (file-relative-name file src-dir))
             (dest-path (concat dest-dir relative-path)))
        (make-directory (file-name-directory dest-path) t)
        (copy-file file dest-path t)))))

(defun copy-image-assets ()
  "Copy theme assets to publish directory."
  (let ((src-dir "~/Vault/Web/spiperac.dev/content/posts/")
        (dest-dir "~/Vault/Web/spiperac.dev/public/posts/"))

    ;; Copy assets directory
    (dolist (file (directory-files-recursively (concat src-dir "images/") ".*"))
      (let* ((relative-path (file-relative-name file src-dir))
             (dest-path (concat dest-dir relative-path)))
        (make-directory (file-name-directory dest-path) t)
        (copy-file file dest-path t)))))

(defun generate-website ()
  "Generate website from org files."
  (interactive)

    (setq org-html-preamble (with-temp-buffer
                          (insert-file-contents "~/Vault/Web/spiperac.dev/theme/nav.html")
                          (buffer-string)))

    (setq org-html-postamble (with-temp-buffer
                          (insert-file-contents "~/Vault/Web/spiperac.dev/theme/footer.html")
                          (buffer-string)))

    (setq org-html-head (with-temp-buffer
                          (insert-file-contents "~/Vault/Web/spiperac.dev/theme/head.html")
                          (buffer-string)))

    (setq org-html-head-include-default-style nil
          org-html-head-include-scripts nil
          org-html-validation-link nil
          org-html-doctype "html5"
          org-html-html5-fancy t
          )

    (setq org-publish-project-alist
          '(("spiperac.dev"
             :recursive t
             :base-directory "~/Vault/Web/spiperac.dev/content"
             :publishing-function org-html-publish-to-html
             :publishing-directory "~/Vault/Web/spiperac.dev/public"
             :with-author nil
             :with-toc t
             :section-numbers nil
             :time-stamp-file nil
             :html-container-element "content"
             )))

    (org-publish-all t)
    (copy-theme-assets)
    (copy-image-assets)
    (message "Website generation complete!"))

(with-eval-after-load 'org
  (define-key org-custom-prefix (kbd "b") 'generate-website))
  
(provide 'website)
;;; website.el ends here

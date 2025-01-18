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
        (dest-dir "~/Vault/Web/spiperac.dev/public/"))

    ;; Copy assets directory
    (dolist (file (directory-files-recursively (concat src-dir "images/") ".*"))
      (let* ((relative-path (file-relative-name file src-dir))
             (dest-path (concat dest-dir relative-path)))
        (make-directory (file-name-directory dest-path) t)
        (copy-file file dest-path t)))))

(defun generate-website ()
  (interactive)
  (setq org-html-validation-link nil)
  (setq org-html-head-include-scripts nil)
  (setq org-html-postamble nil)
  (setq org-html-head-include-default-style nil)
  (setq org-html-head (with-temp-buffer
                       (insert-file-contents "~/Vault/Web/spiperac.dev/theme/template.html")
                       (buffer-string)))
  (setq org-publish-project-alist
        (list
         (list "spiperac.dev"
               :recursive t
               :base-directory "~/Vault/Web/spiperac.dev/content"
               :publishing-function 'org-html-publish-to-html
               :publishing-directory "~/Vault/Web/spiperac.dev/public"
               :with-author nil
               :with-creator t
               :with-toc t
               :section-numbers nil
               :time-stamp-file nil)))
  (org-publish-all t)
  (copy-theme-assets)  ; Copy css from theme/ directory
  (copy-image-assets)  ; Copy images from content
  (message "Building Website complete!"))

(global-set-key (kbd "C-c w") 'generate-website)
(provide 'website)
;;; website.el ends here

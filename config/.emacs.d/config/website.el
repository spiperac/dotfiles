;;; website --- Build Personal Website from Org files
;;; Commentary:
;; Configuration file containing tools to build a personal website.

;;; Code:

;; Loading publishing system
(require 'ox)

(use-package htmlize
  :defer t)

(defun generate-website ()
    (interactive)
    (setq org-html-validation-link nil)
    (setq org-html-head-include-scripts nil)
    (setq org-html-head-include-default-style nil)
    (setq org-publish-project-alist
        (list
        (list "spiperac-site"
                :recursive t
                :base-directory "~/Vault/Web/content"
                :publishing-function 'org-html-publish-to-html
                :publishing-directory "~/Vault/Web/public"
                :with-author nil
                :with-creator t
                :with-toc t                ;; Table of content
                :section-numbers nil
                :time-stamp-file nil
                )
        ))

    (org-publish-all t)
    (message "Building Website complete!"))

(global-set-key (kbd "C-c w") 'generate-website)
(provide 'website)
;;; website.el ends here

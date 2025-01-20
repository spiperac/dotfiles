;;; website --- Build Personal Website from Org files
;;; Commentary:
;; Configuration file containing tools to build a personal website.

;;; Code:

;; Loading publishing system
(require 'ox)
(require 'org)

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

(defun copy-file-assets ()
  "Copy general files to publish directory."
  (let ((src-dir "~/Vault/Web/spiperac.dev/files/")
        (dest-dir "~/Vault/Web/spiperac.dev/public/"))

    ;; Copy assets directory
    (dolist (file (directory-files-recursively src-dir ".*"))
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
    (copy-file-assets)
    (copy-theme-assets)
    (copy-image-assets)
    (message "Website generation complete!"))

;; Function for saving image from clipboard via org-download in ./images/<buffer_name> directory 
(defun my-org-download-path (filename)
  "Generate the full download path for FILENAME."
  (let* ((raw-name (or (buffer-file-name) (buffer-name)))
         (base-name (downcase 
                    (file-name-sans-extension 
                     (file-name-nondirectory raw-name))))
         (timestamp (format-time-string "%Y-%m-%d_%H-%M-%S"))
         (file-base (downcase (file-name-base filename)))
         (file-ext (file-name-extension filename))
         ;; Ensure we're using absolute path
         (target-dir (expand-file-name 
                     (concat "images/" base-name)
                     (file-name-directory raw-name)))
         (target-file (format "%s_%s.%s" timestamp file-base file-ext)))
    ;; Create directory if it doesn't exist
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))
    (expand-file-name target-file target-dir)))

;; Custom advice to prevent directory creation
(defun my-prevent-unwanted-dirs (orig-fun &rest args)
  "Advice to prevent creation of unwanted directories."
  (let ((org-download-image-dir nil)
        (org-download-heading-lvl nil)
        (org-download-method nil))
    (apply orig-fun args)))

(use-package org-download
  :after org
  :config
  ;; Core settings
  (setq org-download-method nil)
  (setq org-download-image-dir nil)
  (setq org-download-heading-lvl nil)
  (setq org-download-use-org-id nil)
  (setq org-download-timestamp "%Y-%m-%d_%H-%M-%S")
  
  ;; Use temporary file for screenshots
  (setq org-download-screenshot-file 
        (expand-file-name "image.png" temporary-file-directory))
  
  ;; Use our custom path function
  (setq org-download-file-format-function #'my-org-download-path)
  
  ;; Add advice to core functions
  (advice-add 'org-download-image :around #'my-prevent-unwanted-dirs)
  (advice-add 'org-download--image/internal :around #'my-prevent-unwanted-dirs)
  (advice-add 'org-download--image/command :around #'my-prevent-unwanted-dirs)
  
  ;; Override directory-related functions
  (defalias 'org-download-dir (lambda () ""))
  (setq org-download-make-dir-func (lambda (_) nil))
  
  ;; Bind clipboard paste
  (define-key org-mode-map (kbd "C-S-v") #'org-download-clipboard))

;; Cleanup advice
(defun my-org-download-cleanup (&rest _)
  "Clean up temporary screenshot files."
  (when (and org-download-screenshot-file
             (file-exists-p org-download-screenshot-file))
    (delete-file org-download-screenshot-file)))

(advice-add 'org-download-screenshot :after #'my-org-download-cleanup)

(defun my-get-blog-metadata (file)
  "Extract title and date from a blog post FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (let ((title (when (re-search-forward "^#\\+title:\\s-*\\(.*\\)$" nil t)
                  (match-string 1)))
          (date (when (re-search-forward "^#\\+date:\\s-*\\(.*\\)$" nil t)
                 (match-string 1))))
      (when (and title date)
        (list :file (file-name-nondirectory file)
              :title title
              :date date)))))

(defun my-regenerate-blog-index ()
  "Scan posts directory and regenerate index.org with sorted entries."
  (interactive)
  (let* ((posts-dir "~/Vault/Web/spiperac.dev/content/posts")
         (index-file "~/Vault/Web/spiperac.dev/content/index.org")
         (posts-list nil))
    
    ;; Collect all blog posts and their metadata
    (dolist (file (directory-files posts-dir t "\\.org$"))
      (when-let ((metadata (my-get-blog-metadata file)))
        (push metadata posts-list)))
    
    ;; Sort posts by date (newest first)
    (setq posts-list 
          (sort posts-list 
                (lambda (a b) 
                  (string-greaterp (plist-get a :date) 
                                 (plist-get b :date)))))
    
    ;; Update index.org
    (with-current-buffer (find-file-noselect index-file)
      (goto-char (point-min))
      (when (re-search-forward "My blog posts:" nil t)
        ;; Clear existing list
        (let ((start (point)))
          (while (re-search-forward "^+" nil t))
          (delete-region start (point)))
        ;; Insert newline after header
        (insert "\n")
        (insert "@@html:<div class=\"blog-post-list\">@@\n")
        ;; Add all posts
        (dolist (post posts-list)
          (insert "@@html:<div class=\"blog-post-item\">@@\n")
          (insert "@@html:<div class=\"blog-post-title\">@@")
          (insert (format "[[file:posts/%s][%s]]"
                         (plist-get post :file)
                         (plist-get post :title)))
          (insert "@@html:</div>@@\n")
          (insert (format "@@html:<div class=\"blog-post-date\">@@%s@@html:</div>@@\n"
                         (plist-get post :date)))
          (insert "@@html:</div>@@\n"))
        (insert "@@html:</div>@@\n"))
      (save-buffer))
    (message "Blog index regenerated with %d posts" (length posts-list))))

;; The existing single-post function, modified for the new posts directory
(defun my-add-blog-to-index ()
  "Add current blog post to index.org list with date and title."
  (interactive)
  (let* ((current-file (buffer-file-name))
         (blog-title (save-excursion
                      (goto-char (point-min))
                      (when (re-search-forward "^#\\+title:\\s-*\\(.*\\)$" nil t)
                        (match-string 1))))
         (blog-date (save-excursion
                     (goto-char (point-min))
                     (when (re-search-forward "^#\\+date:\\s-*\\(.*\\)$" nil t)
                       (match-string 1))))
         (relative-path (concat "posts/" (file-name-nondirectory current-file)))
         (index-file "~/Vault/Web/spiperac.dev/content/index.org"))
    
    (if (and blog-title blog-date current-file)
        (save-excursion
          (with-current-buffer (find-file-noselect index-file)
            (goto-char (point-min))
            (when (re-search-forward "My blog posts:" nil t)
              (forward-line 1)
              (insert (format "+ %s | [[file:%s][%s]]\n" 
                            blog-date
                            relative-path
                            blog-title)))
            (save-buffer)))
      (message "Couldn't find required blog post information!"))))

;; Key bindings
(with-eval-after-load 'org
  (define-prefix-command 'org-custom-prefix)
  (define-key org-mode-map (kbd "C-c C-x b") 'org-custom-prefix)
  (define-key org-custom-prefix (kbd "b") 'generate-website)
  (define-key org-custom-prefix (kbd "i") #'my-add-blog-to-index)
  (define-key org-custom-prefix (kbd "I") #'my-regenerate-blog-index))


(provide 'website)
;;; website.el ends here

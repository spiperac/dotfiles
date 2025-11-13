;;; blog.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains blog helper functions for zola static site generator.
;;; Code:


(setq spiperac/zola-content-dir "~/projects/spiperac.github.io/")

(defun spiperac/zola-new-post (title &optional)
  "Create and visit a new post for the prompted TITLE."
  (interactive "sTitle: ")
  (let* ((slug (s-dashed-words title))
         (default-directory (concat spiperac/zola-content-dir
                                    "content/posts/"))
         (fpath (concat default-directory (format-time-string "%Y-%m-%d-") slug ".md")))
    
    (write-region (concat
                   "+++"
                   "\ntitle = '" title "'"
                   "\ndate = " (format-time-string "%Y-%m-%d %H:%M:%S%:z")
                   "\nslug = \"" slug "\""
                   "\n[taxonomies]"
                   "\n  tags = [\"misc\"]"
                   "\n+++\n\n")
                  nil (expand-file-name fpath) nil nil nil t)
    (find-file (expand-file-name fpath))))


(provide 'blog)
;;; blog.el ends here

;;; orgs.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains custom Org Mode stuff.

;;; Code:

(require 'org)

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

;; Pomodoro
(setq org-clock-sound "~/.emacs.d/asset/boat.wav")

;; Org-Capture
(defun my/org-capture-create-directories ()
  "Create the directories for the capture files if they don't exist."
  (let ((file (expand-file-name org-default-notes-file)))
    (unless (file-exists-p (file-name-directory file))
      (make-directory (file-name-directory file) t))))

(add-hook 'org-capture-before-finalize-hook 'my/org-capture-create-directories)
(add-to-list 'org-agenda-files "~/Vault/Org/todo.org")

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Vault/Org/todo.org" "Tasks")
         "* TODO %?\n  %u")
        ("n" "Note" entry (file+headline "~/Vault/Org/notes.org" "Notes")
         "* %?\n  %u")
        ("b" "Blog post" plain
         (file (lambda ()
                (let* ((title (read-string "Title: "))
                       (date (format-time-string "%Y-%m-%d"))
                       (filename (concat "~/Vault/Org/"
                                       (downcase
                                        (replace-regexp-in-string
                                         "[^a-zA-Z0-9]" "-"
                                         title))
                                       "-"
                                       date
                                       ".org")))
                  (setq org-capture-blog-title title)
                  (expand-file-name filename))))
         ":PROPERTIES:\n:TITLE: %(or org-capture-blog-title \"\")\n:DATE: %<%Y-%m-%d>\n:DESCRIPTION:\n:TAGS:\n:END:\n\n%?")))

(defun org-export-to-zola ()
  "Export current org file to Zola markdown format"
  (interactive)
  (let* ((org-file (buffer-file-name))
         (base-name (file-name-nondirectory org-file))
         (md-file (concat "~/blog/content/post/"
                         (file-name-sans-extension base-name)
                         ".md"))
         (title (org-entry-get (point-min) "TITLE"))
         (date (org-entry-get (point-min) "DATE"))
         (desc (org-entry-get (point-min) "DESCRIPTION"))
         (tags (org-entry-get (point-min) "TAGS")))
    
    ;; Create post directory if it doesn't exist
    (make-directory "~/blog/content/post/" t)
    
    ;; Export to temporary markdown file
    (org-md-export-to-markdown)
    
    ;; Create final markdown with frontmatter
    (with-temp-file md-file
      (insert "+++\n")
      (insert (format "title = \"%s\"\n" title))
      (insert (format "date = %s\n" date))
      (when (and desc (not (string= desc "")))
        (insert (format "description = \"%s\"\n" desc)))
      (when (and tags (not (string= tags "")))
        (insert "[taxonomies]\ntags = [" tags "]\n"))
      (insert "+++\n\n")
      
      ;; Add content without TOC
      (insert-file-contents (concat (file-name-sans-extension org-file) ".md"))
      (goto-char (point-min))
      (when (looking-at "# Table of Contents\n")
        (delete-region (point-min) (progn (forward-line 1) (point)))))
    
    ;; Remove temporary markdown file
    (delete-file (concat (file-name-sans-extension org-file) ".md"))
    (message "Exported to %s" md-file)))





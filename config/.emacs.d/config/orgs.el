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
                       (filename (concat "~/Vault/Web/content/"
                                       (downcase
                                        (replace-regexp-in-string
                                         "[^a-zA-Z0-9]" "-"
                                         title))
                                       "-"
                                       date
                                       ".org")))
                  (setq org-capture-blog-title title)
                  (expand-file-name filename))))
         "#+title: %(or org-capture-blog-title \"\")\n#+date: %<%Y-%m-%d>\n#+description:\n#+tags:\n\n%?")))

;; Org-Roam Setup
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Vault/Org/Roam/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

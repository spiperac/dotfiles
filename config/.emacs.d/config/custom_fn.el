;;; custom_fn.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains various random utilities and functions.

;;; Code:

;; Treemacs open selected file in vertical split window by pressing C-x vs
(defun treemacs-open-file-in-vsplit ()
  "Open the selected file in a vertical split."
  (interactive)
  (let ((file (treemacs-copy-filename-at-point)))
    (if file
        (progn
          (delete-window (treemacs-get-local-window))
          (split-window-right)
          (find-file file)
          (treemacs-select-window))
      (message "No file selected"))))

(global-set-key (kbd "C-x vs") 'treemacs-open-file-in-vsplit)

;; Kill projectile project and return to dashboard
(defun quit-project-and-go-to-dashboard ()
  "Kill all project buffers and return to the dashboard."
  (interactive)
  (let ((project-root (projectile-project-root)))
    (when project-root
      (projectile-kill-buffers))
    (dashboard-refresh-buffer)
    (switch-to-buffer "*dashboard*")))

(global-set-key (kbd "C-c q") 'quit-project-and-go-to-dashboard)

;; ERC in new window
(defun my-erc-in-new-tab ()
  "Open ERC in a new tab."
  (interactive)
  (tab-new)
  (erc :server "irc.libera.chat" :port 6667 :nick "cqmort"))

(global-set-key (kbd "C-c e") 'my-erc-in-new-tab)


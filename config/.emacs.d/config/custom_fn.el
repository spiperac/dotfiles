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


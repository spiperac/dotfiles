;;; custom_fn.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains various random utilities and functions.

;;; Code:

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


(provide 'custom_fn)
;;; custom_fn.el ends here

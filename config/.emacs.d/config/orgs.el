(require 'org)

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

;; Pomodoro
(setq org-clock-sound "~/.emacs.d/asset/ding.wav")

;; Org-Capture
(defun my/org-capture-create-directories ()
  "Create the directories for the capture files if they don't exist."
  (let ((file (expand-file-name org-default-notes-file)))
    (unless (file-exists-p (file-name-directory file))
      (make-directory (file-name-directory file) t))))

(add-hook 'org-capture-before-finalize-hook 'my/org-capture-create-directories)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Vault/Org/todo.org" "Tasks")
         "* TODO %?\n  %u")
        ("n" "Note" entry (file+headline "~/Vault/Org/notes.org" "Notes")
         "* %?\n  %u")))

(add-to-list 'org-agenda-files "~/Vault/Org/todo.org")

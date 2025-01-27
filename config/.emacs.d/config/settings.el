;;; settings.el --- Common settings file -*- lexical-binding: t; -*-
;;; Commentary:
;; Contains common settings.
;;; Code:

(setq inhibit-startup-message t)
(setq calendar-week-start-day 1)
;; Warnings off
;;(setq warning-minimum-level :error)

;; Basic settings
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)

;; Adding local/bin for some LSP servers
(add-to-list 'exec-path "~/.local/bin")
(add-to-list 'exec-path "~/.composer/vendor/bin")
(setenv "PATH" (concat (getenv "PATH") ":~/.local/bin"))
(setenv "PATH" (concat (getenv "PATH") ":~/.composer/vendor/bin"))

;; Auto pair brackets and stuff
(electric-pair-mode 1)

;; Backup files path ( to stop spamming project repositories) 
(setq backup-directory-alist `(("." . "~/.cache/emacs/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.cache/emacs/autosaves/" t)))
(setq auto-save-list-file-prefix "~/.cache/emacs/auto-save-list/.saves-")

(setq create-lockfiles nil)
(setq auto-save-default nil)

;; Allow y/n instead of having to type yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Tabs and spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; Font
(set-face-attribute 'default nil :font "Hack Nerd Font" :height 140)
(force-mode-line-update)

(provide 'settings)
;;; settings.el ends here

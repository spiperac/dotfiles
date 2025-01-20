;;; settings.el --- Common settings file -*- lexical-binding: t; -*-
;;; Commentary:
;; Contains common settings.
;;; Code:

(setq inhibit-startup-message t)
;; Make everyting unicode
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8
    coding-system-for-read 'utf-8
    coding-system-for-write 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; Warnings off
;;(setq warning-minimum-level :error)

;; Basic settings
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)

;; Adding local/bin for some LSP servers
(add-to-list 'exec-path "~/.local/bin")
(setenv "PATH" (concat (getenv "PATH") ":~/.local/bin"))

;; Auto pair brackets and stuff
(electric-pair-mode 1)

;; Backup files path ( to stop spamming project repositories) 
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))

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

;;; settings.el --- Common settings file -*- lexical-binding: t; -*-
;;; Commentary:
;; Contains common settings.
;;; Code:

(setq inhibit-startup-message t)
(setq calendar-week-start-day 1)
(setq scroll-margin 8
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

;; Basic settings
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)
(setq display-line-numbers-type 'relative) 
(global-display-line-numbers-mode)

;; NixOS bin path
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin")))

;; Fonts
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 120)
(force-mode-line-update)

;; Tabs and spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Scrolling
(setq pixel-scroll-precision-mode t)

;; Auto pair brackets and stuff
(electric-pair-mode 1)

;; Backup files path ( to stop spamming project repositories) 
;;(setq make-backup-files nil)
(setq backup-directory-alist `(("." . "~/.cache/emacs/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.cache/emacs/autosaves/" t)))
(setq auto-save-list-file-prefix "~/.cache/emacs/auto-save-list/.saves-")

(setq create-lockfiles nil)
(setq auto-save-default nil)

;; Allow y/n instead of having to type yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Adding local/bin for some LSP servers
(add-to-list 'exec-path "~/.local/bin")
(add-to-list 'exec-path "~/.composer/vendor/bin")
(setenv "PATH" (concat (getenv "PATH") ":~/.local/bin"))
(setenv "PATH" (concat (getenv "PATH") ":~/.composer/vendor/bin"))

(provide 'settings)
;;; settings.el ends here

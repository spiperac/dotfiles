;;; init.el --- User Emacs configuration -*- lexical-binding: t; -*-

;; Author: spiperac <spiperac@denkei.org>
;; Keywords: internal
;; URL: https://spiperac.dev/

;;; Commentary:
;; This file contains the Emacs configuration for spiperac.
;; Organized for clarity and modularity.

;;; Code:

;; 1. First set up custom-file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file :noerror)

(add-to-list 'load-path "~/.emacs.d/config/")
(load "packages")
(load "languages")
(load "ui")
(load "keybinds")
(load "orgs")
(load "chat")
(load "pomodoro")
(load "custom_fn")
(load "website")

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

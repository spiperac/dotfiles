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

(setq use-package-compute-statistics t)
(add-to-list 'load-path "~/.emacs.d/config/")
(load "settings")
(load "packages")
(load "lsp")
(load "orgs")

;; features
(load "chat")
(load "email")
(load "pomodoro")
(load "website")
(load "news")
(load "custom_fn")

;; Theme and keybinds
(load "ui")
(load "keybinds")

(provide 'init)
;;; init.el ends here

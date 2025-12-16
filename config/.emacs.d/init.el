;;; init.el --- User Emacs configuration -*- lexical-binding: t; -*-

;; Author: spiperac <spiperac@denkei.org>
;; Keywords: internal
;; URL: https://spiperac.dev/

;;; Commentary:
;; This file contains the Emacs configuration for spiperac.
;; Organized for clarity and modularity.

;;; Code:
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")  ; char-displayable-p returns 'unicode
(set-language-environment "English")  ; char-displayable-p returns nil

;; 1. First set up custom-file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file :noerror)

(setq use-package-compute-statistics t)
(add-to-list 'load-path "~/.emacs.d/config/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Basic configuration
(load "settings")
(load "packages")
(load "lsp")

;; Theme and keybinds
(load "theme")
(load "keybinds")

;; Addons
(load "music")
(load "blog")
(load "custom_fn")

(provide 'init)
;;; init.el ends here

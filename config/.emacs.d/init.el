(add-to-list 'load-path "~/.emacs.d/config/")
(load "packages")
(load "languages")
(load "ui")
(load "keybinds")
(load "orgs")
(load "pomodoro")
(load "custom_fn")

;; Adding local/bin for some LSP servers
(add-to-list 'exec-path "~/.local/bin")
(setenv "PATH" (concat (getenv "PATH") ":~/.local/bin"))

(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)

;; Basic settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
;(set-fringe-mode 10)
(setq inhibit-startup-message t)

;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))

;; Allow y/n instead of having to type yes/no
(use-package emacs
  :init
  (defalias 'yes-or-no-p 'y-or-n-p))

;; Tabs and spaces
(use-package emacs
  :init
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2))

;; Font
(set-face-attribute 'default nil :font "Hack Nerd Font" :height 140)
(force-mode-line-update)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e1da45d87a83acb558e69b90015f0821679716be79ecb76d635aafdca8f6ebd4" "0517759e6b71f4ad76d8d38b69c51a5c2f7196675d202e3c2507124980c3c2a3" "11819dd7a24f40a766c0b632d11f60aaf520cf96bd6d8f35bae3399880937970" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "34cf3305b35e3a8132a0b1bdf2c67623bc2cb05b125f8d7d26bd51fd16d547ec" default))
 '(package-selected-packages
   '(vertico vertico-posframe lsp-pyre gruvbox-theme eglot leuven-theme lsp-pyright go-mode evil company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

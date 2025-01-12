(add-to-list 'load-path "~/.emacs.d/config/")
(load "packages")
(load "languages")
(load "ui")
(load "keybinds")

(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)

;; Basic settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(set-fringe-mode 10)
(setq inhibit-startup-message t)

;; Font
(set-face-attribute 'default nil :font "Hack Nerd Font" :height 140)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(leuven-theme lsp-pyright go-mode evil company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

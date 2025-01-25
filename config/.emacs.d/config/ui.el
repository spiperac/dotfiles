;;; package --- UI And Themes
;;; Commentary:
;; Configuration file containing themes, and other ui elements.

;;; Code:

;; Basic UI Settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(setq tab-bar-show 1)
(set-fringe-mode 10)
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . light))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; Display line numbers only in prog-mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; Hide Window Border
(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t))

;; Load Theme
;; Add the custom themes directory to the load path
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load "~/.emacs.d/themes/one-themes.el")
;; (load-theme 'one-dark t)

(use-package monokai-pro-theme
  :ensure t
  :config
  (load-theme 'monokai-pro t))

;(set-face-background 'line-number (face-background 'default))
;(set-face-background 'line-number-current-line (face-background 'default))

(use-package doom-modeline
  :ensure t 
  :init (doom-modeline-mode 1)
  :config
  (column-number-mode 1)
  (setq doom-modeline-height 40)
  )

(use-package nerd-icons)

;; Dashboard Configuration
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)
                          (agenda . 5)))
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-startup-banner "~/.config/wallpapers/avatar/dharma.png")
  (dashboard-center-content t)
  (dashboard-projects-backend 'projectile)
  (dashboard-set-init-info t)
  (dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t))
(advice-add #'dashboard-replace-displayable :override #'identity)

;; Adds color to nested parentheses, braces, and brackets.
(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (text-mode . rainbow-delimiters-mode)))

;; Padding


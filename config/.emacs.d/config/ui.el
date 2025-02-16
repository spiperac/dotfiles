;;; package --- UI And Themes
;;; Commentary:
;; Configuration file containing themes, and other ui elements.

;;; Code:

;; Basic UI Settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(set-fringe-mode 10)
(setq tab-bar-show 1)
(setq frame-title-format nil)

;; If titlebar is enabled, format.
(setq frame-title-format
      '((:eval
         (concat
          ;; Modified status
          (if (buffer-modified-p) "*" "")
          
          ;; Icon
          (if (buffer-file-name)
              (nerd-icons-icon-for-file (buffer-file-name))
            (nerd-icons-icon-for-mode major-mode))
          " "
          ;; Project name if in a project
          (when (projectile-project-p)
            (concat " [" (projectile-project-name) "] "))
          ;; File name relative to project root, or just buffer name if not in a file
          (if (buffer-file-name)
              (if (projectile-project-p)
                  (file-relative-name (buffer-file-name) (projectile-project-root))
                (file-name-nondirectory (buffer-file-name)))
            "%b")))))

;; Display line numbers only in prog-mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; Hide Window Border
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;;(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t)) ;; removes titlebar 
(add-to-list 'default-frame-alist '(undecorated-round . t))
;(modify-all-frames-parameters '((internal-border-width . 6)))
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
  (column-number-mode nil)
  (setq doom-modeline-height 40)
  (setq doom-modeline-icon t)
  (setq doom-modeline-modal-icon nil)
  (setq doom-modeline-buffer-file-name-style "file-name")
  (set-face-attribute 'mode-line nil :height 140)  ; Adjust the height (e.g., 140%)
)

(setq evil-normal-state-tag   (propertize "[NORMAL]" 'face '((:foreground "green" :weight 'bold)))
      evil-emacs-state-tag    (propertize "[Emacs]" 'face '((:background "orange" :foreground "black")))
      evil-insert-state-tag   (propertize "[INSERT]" 'face '((:background "red") :foreground "red" :weight 'bold))
      evil-motion-state-tag   (propertize "[Motion]" 'face '((:background "blue") :foreground "white"))
      evil-visual-state-tag   (propertize "[Visual]" 'face '((:background "grey80" :foreground "black")))
      evil-operator-state-tag (propertize "[Operator]" 'face '((:background "purple"))))


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
  (dashboard-startup-banner "~/.emacs.d/asset/dharma.png")
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

;; Breadcrumbs

(use-package breadcrumb
  :ensure t
  :config
  (breadcrumb-mode 1))


;; Transparency
(set-frame-parameter nil 'alpha-background 98) ; For current frame
(add-to-list 'default-frame-alist '(alpha-background . 98)) ; For all new frames henceforth

(provide 'ui)
;;; ui.el ends here

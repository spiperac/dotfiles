(use-package monokai-pro-theme
  :ensure t
  :config
  (load-theme 'monokai-pro t))

;(set-frame-parameter nil 'alpha '(98 . 100))
(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t))

(use-package doom-modeline
  :ensure t 
  :init (doom-modeline-mode 1)
  :config (column-number-mode 1)
  )

(use-package nerd-icons)
(use-package spacious-padding
  :ensure t 
  :hook (after-init . spacious-padding-mode))

;; Dashboard Configuration
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)
                          (agenda . 5)))
  (setq dashboard-center-content t)
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-set-init-info t)
  (dashboard-setup-startup-hook))



;; Centaur Tabs
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))
(setq centaur-tabs-style "alternate")
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-icon-type 'nerd-icons)  ; or 'nerd-icons
(setq centaur-tabs-height 32)
(setq centaur-tabs-gray-out-icons 'buffer)
(setq centaur-tabs-set-bar 'over)
(setq centaur-tabs-set-modified-marker t)
(setq centaur-tabs-cycle-scope 'tabs)
(add-hook 'dired-mode-hook 'centaur-tabs-local-mode)
(add-hook 'dashboard-mode-hook 'centaur-tabs-local-mode)

;; Adds color to nested parentheses, braces, and brackets.
(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (text-mode . rainbow-delimiters-mode)))

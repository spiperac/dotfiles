(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t))

;(set-frame-parameter nil 'alpha '(98 . 100))
(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t))

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t 
  :init (doom-modeline-mode 1)
  :config (column-number-mode 1)
  )

(use-package spacious-padding
  :ensure t 
  :hook (after-init . spacious-padding-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
            

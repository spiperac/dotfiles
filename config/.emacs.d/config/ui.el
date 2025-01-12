(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t))
(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t))

;;(use-package doom-themes
;;  :ensure t
;;  :config
;;  (load-theme 'doom-one t))

(use-package all-the-icons
  :ensure t)

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode))

;; Evil
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

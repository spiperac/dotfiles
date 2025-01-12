;(use-package leuven-theme
;  :ensure t
;  :config
;  (load-theme 'leuven-dark t))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

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

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t))

;(set-frame-parameter nil 'alpha '(98 . 100))
(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t))

(use-package all-the-icons
  :ensure t)



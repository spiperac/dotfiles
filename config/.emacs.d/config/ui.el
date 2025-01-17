;;; package --- UI And Themes
;;; Commentary:
;; Configuration file containing themes, and other ui elements.

;;; Code:

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  (doom-themes-org-config))


;(set-frame-parameter nil 'alpha '(98 . 100))
(set-frame-parameter nil 'internal-border-width 0)
(add-to-list 'default-frame-alist '(undecorated . t))

(use-package doom-modeline
  :ensure t 
  :init (doom-modeline-mode 1)
  :config (column-number-mode 1)
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
  (setq dashboard-center-content t)
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-set-init-info t)
  (dashboard-setup-startup-hook))


;; Adds color to nested parentheses, braces, and brackets.
(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (text-mode . rainbow-delimiters-mode)))

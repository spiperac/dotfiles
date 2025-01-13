(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
(use-package command-log-mode)

;; General
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package magit
  :ensure t)

(use-package treemacs
  :ensure t
  :bind ("C-c n" . treemacs)
  :custom
  (treemacs-is-never-other-window t)
  (treemacs-position 'right)
  :hook
  (treemacs-mode . treemacs-project-follow-mode)
  )

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

;; LSP Configuration

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; Eglot Settings
(use-package eglot
  :ensure t)

;; Company Configuration
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))
;; Ensure eglot and company work together
(add-hook 'eglot-managed-mode-hook
          (lambda () (setq-local company-backends '((company-capf)))))
(global-company-mode 1)

(use-package eldoc-box
  :ensure t
  :config
  (setq eldoc-box-doc-enable t)) ; Enables doc with syntax highlighting

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package projectile
  :ensure t
  :init
  (setq projectile-keymap-prefix (kbd "C-c p")) ;; Set keymap prefix before loading
  :config
  (projectile-mode 1))


;; Vertico posframe launch box
(use-package vertico-posframe
  :ensure t 
  :custom
  (vertico-posframe-parameters
      '((left-fringe . 8)
        (right-fringe . 8))))
             

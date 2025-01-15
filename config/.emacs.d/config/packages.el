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
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)

  :hook
  (treemacs-mode . treemacs-project-follow-mode))

(use-package treemacs-nerd-icons
  :ensure t
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(setq treemacs-icon-theme 'nerd-icons)

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode))

;; Evil
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode 1))

;; LSP Configuration
;; Eglot Settings
(use-package eglot
  :ensure t)

;; Company Configuration
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-selection-wrap-around t)
  (setq company-tooltip-doc-enable t)
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

(use-package company-box
  :hook (company-mode . company-box-mode))

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
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package vertico-posframe
  :ensure t
  :custom
  (vertico-posframe-poshandler 'posframe-poshandler-frame-center)
  :config
  (vertico-posframe-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package consult
  :ensure t)

(setq consult-project-root-function #'consult--project-root) ;; Enable project-based search


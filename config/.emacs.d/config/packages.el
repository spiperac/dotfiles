;;; packages.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains most of the package installation and configuration.

;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; General
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package magit
  :ensure t
  :defer t)

(use-package vterm
  :ensure t
  :defer t)

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
(add-hook 'dired-mode-hook 'diff-hl-dired-mode)

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands))

(use-package nerd-icons :defer t)
(use-package nerd-icons-dired
  :commands (nerd-icons-dired-mode))
(setq dired-sidebar-theme 'nerd-icons)

;; Evil
(use-package evil
  :ensure t
  :config
  (evil-mode 1))
(evil-set-undo-system 'undo-redo)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

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

;; Install and configure Marginalia
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Install and configure Nerd-Icons-Completion
(use-package nerd-icons-completion
  :ensure t
  :after (marginalia)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :init
  (nerd-icons-completion-mode))


;; Documents handling

;; PDF Tools
(use-package pdf-tools
  :ensure t
  :defer t
  :config
  (pdf-tools-install))
(add-hook 'pdf-view-mode-hook #'pdf-view-themed-minor-mode)

(use-package nyan-mode
  :init
  (nyan-mode))

(provide 'packages)
;;; packages.el ends here 

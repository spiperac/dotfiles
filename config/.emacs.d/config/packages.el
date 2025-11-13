
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

(use-package xclip
  :ensure t
  :config
  (setq xclip-program "wl-copy")
  (setq xclip-select-enable-clipboard t)
  (setq xclip-mode t)
  (setq xclip-method (quote wl-copy)))

;; Evil
(use-package evil
  :init
  (setq evil-want-keybinding nil) 
  (setq evil-want-C-u-scroll t
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-set-undo-system 'undo-redo)
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init 'magit))

;; Vertico
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t))

;; Orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

;; Consult
(use-package consult
  :custom
  (consult-async-min-input 0))

;; Magit
(use-package magit
  :ensure t)

;; Which-key
(use-package which-key
  :config
  (which-key-mode))

;; Direnv for flakes
(use-package direnv
 :ensure t
 :config
 (direnv-mode))

(provide 'packages)
;;; packages.el ends here


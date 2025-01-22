;;; languages.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains LSP configurations and syntax highlighting.

;;; Code:

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
        company-minimum-prefix-length 1)
  (setq company-global-modes '(not org-mode magit-mode)))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; Ensure eglot and company work together
(add-hook 'eglot-managed-mode-hook
          (lambda () (setq-local company-backends '((company-capf)))))

(use-package eldoc-box
  :ensure t
  :config
  (setq eldoc-box-doc-enable t)) ; Enables doc with syntax highlighting

;; Treesitter languages
(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
       (css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
       (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
       (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.1" "src"))
       (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
       (markdown . ("https://github.com/ikatyang/tree-sitter-markdown" "v0.7.1"))
       (toml . ("https://github.com/tree-sitter/tree-sitter-toml" "v0.5.1"))
       (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
       (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
       (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))))

(setq major-mode-remap-alist
      '((js-mode . javascript-ts-mode)
        (css-mode . css-ts-mode)
        (html-mode . html-ts-mode)
        (json-mode . json-ts-mode)
        (toml-mode . toml-ts-mode)
        (tsx-mode . tsx-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (yaml-mode . yaml-ts-mode)))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-ts-mode))

;; PROGRAMMING LANGUAGES ;;

(add-hook 'before-save-hook #'eglot-format-buffer)

;; C and Cpp
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; Python
(add-hook 'python-mode-hook 'eglot-ensure)

;; Golang
(use-package go-mode
  :defer t)
(add-hook 'go-mode-hook 'eglot-ensure)

;; Rust
(use-package rust-mode
  :defer t)
(add-hook 'rust-mode-hook 'eglot-ensure)

;; PHP
(use-package php-mode
  :defer t)
(add-hook 'php-mode-hook 'eglot-ensure)

;; Basic Completions
(add-hook 'bash-mode-hook 'company-mode)
(add-hook 'json-mode-hook 'company-mode)
(add-hook 'html-mode-hook 'company-mode)
(add-hook 'tsx-mode-hook 'company-mode)
(add-hook 'css-ts-mode 'company-mode)

;; Lang servers
(setq eglot-server-programs
      '((c-mode . ("clangd"))
        (c++-mode . ("clangd"))
        (python-mode . ("pylsp"))
        (go-mode . ("gopls"))
        (rust-mode . ("rust-analyzer"))
        (typescript-ts-mode . ("typescript-language-server" "--stdio"))
        ))
;; PHP Language server
(add-to-list 'eglot-server-programs '((php-mode) . ("phpactor" "language-server")))

;; References
(require 'semantic/symref/grep)
(with-eval-after-load 'semantic/symref
(add-to-list 'semantic-symref-filepattern-alist
             '(php-mode "*.php" "*.phtml" "*.php5" "*.php7")))


;;; languages.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains LSP configurations and syntax highlighting.

;;; Code:

;; LSP Configuration
;; Eglot Settings
(use-package eglot
  :ensure t)

(use-package eldoc-box
  :ensure t)


;; Corfu Configuration

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :bind (:map corfu-map
         ("C-n" . corfu-next)
         ("C-p" . corfu-previous)
         ("<escape>" . corfu-quit)
         ("<return>" . corfu-insert)
         ("M-d" . corfu-show-documentation)
         ("M-l" . corfu-show-location)
         ("<tab>" . corfu-next)
         ("S-<tab>" . corfu-previous))
  :custom
  (corfu-cycle t)
  (corfu-auto nil)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2)
  (corfu-quit-at-boundary nil)
  (corfu-preselect-first t)
  (corfu-echo-documentation t)
  (corfu-want-tab-prefer-expand-snippets t))

;; Enable indentation and completion using the TAB key.
(setq tab-always-indent 'complete)

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-use-icons t) ; Use Nerd Font icons
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))


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

;; yaml lines mode
(add-hook 'yaml-ts-mode-hook (lambda () (display-line-numbers-mode 1))) 
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
  :defer t
  :config
  (setq rust-format-on-save t))
(add-hook 'rust-mode-hook 'eglot-ensure)

;; PHP
(use-package php-mode
  :defer t)
(add-hook 'php-mode-hook 'eglot-ensure)

;; Markdown
(use-package markdown-mode
  :ensure t)

;; Lang servers
(setq eglot-server-programs
      '((c-mode . ("clangd"))
        (c++-mode . ("clangd"))
        (python-mode . ("pyright-langserver" "--stdio"))
        (go-mode . ("gopls"))
        (rust-mode . ("rust-analyzer"))
        (typescript-ts-mode . ("typescript-language-server" "--stdio"))))

;; PHP Language server
(add-to-list 'eglot-server-programs '((php-mode) . ("phpactor" "language-server")))

;; References
(require 'semantic/symref/grep)
(with-eval-after-load 'semantic/symref
  (add-to-list 'semantic-symref-filepattern-alist
               '(php-mode "*.php" "*.phtml" "*.php5" "*.php7")))

(provide 'lsp)
;;; lsp.el ends here

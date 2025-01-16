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


;; PROGRAMMING LANGUAGES ;;

(add-hook 'before-save-hook #'eglot-format-buffer)

;; C and Cpp
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; Python
(add-hook 'python-mode-hook 'eglot-ensure)

;; Golang
(use-package go-mode)
(add-hook 'go-mode-hook 'eglot-ensure)

;; Rust
(use-package rust-mode)
(add-hook 'rust-mode-hook 'eglot-ensure)

;; Basic Completions
(add-hook 'bash-mode-hook 'company-mode)
(add-hook 'json-mode-hook 'company-mode)
(add-hook 'html-mode-hook 'company-mode)
(add-hook 'tsx-mode-hook 'company-mode)

;; Lang servers
(setq eglot-server-programs
      '((c-mode . ("clangd"))
        (c++-mode . ("clangd"))
        (python-mode . ("pylsp"))
        (go-mode . ("gopls"))
        (rust-mode . ("rust-analyzer"))
        (typescript-ts-mode . ("typescript-language-server" "--stdio"))
        ))


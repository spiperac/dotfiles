(add-hook 'python-mode-hook 'eglot-ensure)

;; Python
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . lsp))

;; Golang
(use-package go-mode
  :ensure t
  :hook (go-mode . eglot-ensure))

(add-hook 'go-mode-hook 'eglot-ensure)

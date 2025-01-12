(add-hook 'python-mode-hook 'eglot-ensure)

;; Python
(add-hook 'python-mode-hook 'eglot-ensure)

;; Golang
(use-package go-mode
  :ensure t
  :hook (go-mode . eglot-ensure))

(add-hook 'go-mode-hook 'eglot-ensure)

(global-set-key (kbd "C-c n") 'treemacs)

;; LSP
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c d") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c k") #'eldoc-box-help-at-point)
  )

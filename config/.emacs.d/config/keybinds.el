;; LSP
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c d") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c k") #'eldoc-box-help-at-point)
  )

;; Consult

(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-x f") 'consult-find)
(global-set-key (kbd "C-c g") 'consult-ripgrep)

;; Vertico
(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous))

;; Centaur tabs
(define-key evil-normal-state-map (kbd "g t") 'centaur-tabs-forward)
(define-key evil-normal-state-map (kbd "g T") 'centaur-tabs-backward)

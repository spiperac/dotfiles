;;; keybinds.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains custom keybinds and remaps.

;;; Code:

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(define-key minibuffer-local-map (kbd "C-j") 'next-line-or-history-element)
(define-key minibuffer-local-map (kbd "C-k") 'previous-line-or-history-element)

(defun my/find-file ()
  (interactive)
  (consult-find (project-root (project-current t))))

(with-eval-after-load 'evil 
    (define-prefix-command 'my-leader-map)
    (evil-define-key 'normal 'global (kbd "SPC") 'my-leader-map)
    (define-key my-leader-map (kbd "sf") 'project-find-file)
    (define-key my-leader-map (kbd "sp") 'project-switch-project)
    (define-key my-leader-map (kbd "sg") 'consult-ripgrep)
    (define-key my-leader-map (kbd "gg") 'magit)
    (define-key my-leader-map (kbd "v") 'evil-window-vsplit)
    (define-key my-leader-map (kbd "o") 'evil-window-next)
    (define-key my-leader-map (kbd "q") 'evil-window-delete)
    (define-key my-leader-map (kbd "h") 'evil-window-split)
    )

;; LSP
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c d") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c c") 'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c k") #'eldoc-box-help-at-point)
  )

;; Corfu completion box
(with-eval-after-load 'corfu
  (with-eval-after-load 'evil
    (define-key evil-insert-state-map (kbd "C-j") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-k") #'corfu-previous)
    (define-key evil-insert-state-map (kbd "C-n") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-p") #'corfu-previous)
    )
  )

(provide 'keybinds)

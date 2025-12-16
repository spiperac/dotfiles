;;; package --- UI And Themes
;;; Commentary:
;; Configuration file containing themes, and other ui elements.

;;; Code:

;; Basic UI Settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(set-fringe-mode 10)
(setq tab-bar-show 1)
(setq frame-title-format nil)

;; Display line numbers only in prog-mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq frame-resize-pixelwise t)
(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(internal-border-width . 0))

(load-theme 'vague t)
(defun spiperac/toggle-theme ()
  "Toggle between vague dark and light themes."
  (interactive)
  (if (custom-theme-enabled-p 'vague)
      (progn
        (disable-theme 'vague)
        (load-theme 'vague-light t))
    (progn
      (disable-theme 'vague-light)
      (load-theme 'vague t))))

(global-set-key (kbd "C-c t") 'spiperac/toggle-theme)

;; (use-package monokai-pro-theme
;;  :ensure t
;;  :config
;;  (load-theme 'monokai-pro t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (column-number-mode nil)
  (setq doom-modeline-height 40)
  (setq doom-modeline-icon t)
  (setq doom-modeline-modal-icon nil)
  (setq doom-modeline-buffer-file-name-style "file-name")
  (set-face-attribute 'mode-line nil :height 140)  ; Adjust the height (e.g., 140%)
)

;; Icons, nerds
(use-package nerd-icons :defer t)
(unless (find-font (font-spec :name "Symbols Nerd Font Mono"))
  (nerd-icons-install-fonts t))

(use-package nerd-icons-dired
  :commands (nerd-icons-dired-mode))
(setq dired-sidebar-theme 'nerd-icons)

(use-package nerd-icons-completion
  :ensure t
  :after (nerd-icons)
  :config
  (nerd-icons-completion-mode))

(setq evil-normal-state-tag   (propertize "[NORMAL]")
      evil-emacs-state-tag    (propertize "[Emacs]")
      evil-insert-state-tag   (propertize "[INSERT]")
      evil-motion-state-tag   (propertize "[Motion]")
      evil-visual-state-tag   (propertize "[Visual]")
      evil-operator-state-tag (propertize "[Operator]"))

;; Adds color to nested parentheses, braces, and brackets.
(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (text-mode . rainbow-delimiters-mode)))

;; Breadcrumbs

(provide 'ui)
;;; ui.el ends here

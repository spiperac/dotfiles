;;; keybinds.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains custom keybinds and remaps.

;;; Code:
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Hydra
(pretty-hydra-define main-leader
  (:title "Main Leader" :color yellow :exit t)
  ("Files"
   (("f" projectile-find-file "Find file")
    ("d" dired "Dired")
    ("t" vterm "vTerm terminal")
    )
   "Buffers"
   (("b" switch-to-buffer "Switch")
    ("k" kill-buffer "Kill"))
   "Windows"
   (("w" split-window-right "Split")
    ("o" other-window "Other"))
   "Search"
   (("s" consult-ripgrep "Ripgrep")
    ("r" projectile-replace "Replace"))
   "Projects"
   (("p" projectile-switch-project "Switch Project"))
   "Quit"
   (("q" delete-window "Close window")
    ("SPC" hydra-keyboard-quit "Close Hydra")))) ;; This is where SPC closes Hydra

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "SPC") 'main-leader/body)
  (evil-define-key 'visual 'global (kbd "SPC") 'main-leader/body))

;; LSP
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c d") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c k") #'eldoc-box-help-at-point)
  )

;; Corfu completion box
(with-eval-after-load 'corfu
  (with-eval-after-load 'evil
    (define-key evil-insert-state-map (kbd "C-j") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-k") #'corfu-previous)
    (define-key evil-insert-state-map (kbd "C-n") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-p") #'corfu-previous)

    ))

;; Consult
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-x f") 'consult-find)
(global-set-key (kbd "C-c g") 'consult-ripgrep)

;; Vertico
(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous))


;; Org shortcuts
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

;; Elfeed
(evil-define-key 'normal elfeed-search-mode-map
  (kbd "RET") 'elfeed-search-show-entry
  (kbd "o") 'elfeed-search-show-entry
  (kbd "s") 'elfeed-search-live-filter
  (kbd "q") 'elfeed-search-quit-window
  (kbd "c") 'elfeed-search-clear-filter
  (kbd "U") 'elfeed-update)

(evil-define-key 'normal elfeed-show-mode-map
  (kbd "q") 'elfeed-kill-buffer)


;; Hydra Keybinds

(defhydra hydra-window (:color blue)
  "Window"
  ("s" split-window-below "Split")
  ("v" split-window-right "V Split")
  ("d" delete-window "Delete")
  ("b" balance-windows "Balance")
  ("q" nil "Quit"))
(global-set-key (kbd "C-c w") #'hydra-window/body)

(provide 'keybinds)
;;; keybinds.el ends here

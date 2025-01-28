;;; keybinds.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains custom keybinds and remaps.

;;; Code:
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Hydra
(defun my-split-and-focus ()
  (interactive)
  (split-window-right)
  (other-window 1))

(pretty-hydra-define main-leader
  (:title "Main Leader" :color yellow :exit t)
  ("Files"
   (("f" projectile-find-file "Find file")
    ("d" dired "Dired")
    ("t" vterm "vTerm terminal")
    ("F" toggle-font-sizes "Toggle Font Size")
    )
   "Buffers"
   (("b" switch-to-buffer "Switch")
    ("k" kill-buffer "Kill"))
   "Windows"
   (("v" my-split-and-focus "Split and Focus")
    ("o" other-window "Other")
    ("w" hydra-window/body "Window options")
    )
   "Git"
   (("g" hydra-magit/body "Magit GIT"))
   "Search"
   (("s" consult-ripgrep "Ripgrep")
    ("r" projectile-replace "Replace"))
   "Social"
   (("M" mu4e "Email"))
   "Projects"
   (("p" projectile-switch-project "Switch Project"))
   "Quit"
   (("q" delete-window "Close window")
    ("SPC" hydra-keyboard-quit "Close Hydra")))) ;; This is where SPC closes Hydra

(defhydra hydra-window (:color blue)
  "Window"
  ("s" split-window-below "Split")
  ("v" split-window-right "V Split")
  ("d" delete-window "Delete")
  ("b" balance-windows "Balance")
  ("q" nil "Quit"))

(pretty-hydra-define hydra-magit
  (:title "Magit Commands" :color teal :quit-key "q")
  ("Status"
   (("s" magit-status "Status")
    ("p" magit-pull "Pull")
    ("f" magit-fetch "Fetch")
    ("d" magit-dispatch "Dispatch")
    ("l" magit-log-all "Log")
    ("r" magit-refresh "Refresh"))
   "Commit"
   (("c" magit-commit "Commit")
    ("a" magit-stage-file "Stage File")
    ("u" magit-unstage-file "Unstage File")
    ("e" magit-edit-commit "Edit Commit")
    ("P" magit-push "Push"))
   "Branches"
   (("b" magit-branch "Branches")
    ("n" magit-branch-and-checkout "New Branch")
    ("m" magit-merge "Merge"))
   "Stashing"
   (("z" magit-stash "Stash")
    ("x" magit-stash-pop "Apply Stash")
    ("v" magit-stash-list "Stash List"))
   "Other"
   (("t" git-timemachine "Timemachine")
    ("q" nil "Quit"))))

(defun toggle-font-sizes ()
 (interactive)
 (set-face-attribute 'default nil :height (if (= (face-attribute 'default :height) 120) 140 120)))

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

(global-set-key (kbd "C-c w") #'hydra-window/body)

(provide 'keybinds)
;;; keybinds.el ends here

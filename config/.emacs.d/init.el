;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-
;; Author: spiperac <spiperac@denkei.org>
;; URL: https://spiperac.dev/
;;; Code:

;; ============================================================
;; SERVER
;; ============================================================

(require 'server)
(unless (server-running-p)
  (server-start))

;; NO LITERING!!
(defvar my-cache-dir "~/.cache/emacs/")

(setq bookmark-default-file       (expand-file-name "bookmarks" my-cache-dir)
      custom-file                  (expand-file-name "custom.el" my-cache-dir)
      place-file                   (expand-file-name "places" my-cache-dir)
      recentf-save-file            (expand-file-name "recentf" my-cache-dir)
      savehist-file                (expand-file-name "history" my-cache-dir)
      ielm-history-file-name       (expand-file-name "ielm-history.eld" my-cache-dir)
      org-id-locations-file        (expand-file-name "org-id-locations" my-cache-dir)
      org-roam-db-location         (expand-file-name "org-roam.db" my-cache-dir)
      projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" my-cache-dir)
      tramp-persistency-file-name  (expand-file-name "tramp" my-cache-dir)
      transient-history-file       (expand-file-name "transient/history.el" my-cache-dir)
      transient-levels-file        (expand-file-name "transient/levels.el" my-cache-dir)
      transient-values-file        (expand-file-name "transient/values.el" my-cache-dir)
      url-configuration-directory  (expand-file-name "url/" my-cache-dir)
      eshell-directory-name        (expand-file-name "eshell/" my-cache-dir)
      auto-save-list-prefix        (expand-file-name "auto-save/.saves-" my-cache-dir))

;; Native comp cache (eln-cache)
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" my-cache-dir)))

;; ============================================================
;; ENCODING
;; ============================================================

(prefer-coding-system 'utf-8)
(set-language-environment "English")

;; ============================================================
;; CUSTOM FILE
;; ============================================================

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file) (write-region "" nil custom-file))
(load custom-file :noerror)

;; ============================================================
;; PACKAGE BOOTSTRAP
;; ============================================================

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-compute-statistics t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; ============================================================
;; CORE SETTINGS
;; ============================================================

(global-auto-revert-mode 1) ;; auto refresh file changed on disk

(setq inhibit-startup-message t
      calendar-week-start-day 1
      select-enable-clipboard t
      select-enable-primary t
      create-lockfiles nil
      auto-save-default nil
      frame-title-format nil
      frame-resize-pixelwise t
      use-short-answers t
      initial-scratch-message ""
      )
(save-place-mode 1) ;; remmembers cursor possition in a file even after closing

;; No sound
(setq visible-bell t)
(setq ring-bell-function 'ignore)

(add-hook 'window-state-change-hook
          (lambda ()
            (if (frame-parameter nil 'fullscreen)
                (set-frame-parameter nil 'undecorated t)
              (set-frame-parameter nil 'undecorated nil))))

(setq-default indent-tabs-mode nil
              tab-width 4)

(advice-add 'org-element-parse-buffer :before
            (lambda (&rest _) (setq-local tab-width 8)))

(add-hook 'org-mode-hook
          (lambda () (setq-local tab-width 8)))

(setq tab-always-indent 'complete)

;; Scrolling
(setq scroll-margin 0
      scroll-conservatively 101
      scroll-step 1
      scroll-preserve-screen-position 1
      auto-window-vscroll nil)

(when (display-graphic-p)
  (pixel-scroll-precision-mode 1))

;; Backups
(setq backup-directory-alist         `(("." . "~/.cache/emacs/backups"))
      auto-save-file-name-transforms `((".*" "~/.cache/emacs/autosaves/" t))
      auto-save-list-file-prefix     "~/.cache/emacs/auto-save-list/.saves-")

;; PATH
(defun spiperac/add-to-path (path)
  (add-to-list 'exec-path path)
  (setenv "PATH" (string-join exec-path ":")))

(mapc #'spiperac/add-to-path
      '("/run/current-system/sw/bin"
        "~/.local/bin"
        "~/.composer/vendor/bin"))

(defun spiperac/reload-config ()
  "Reload init.el configuration."
  (interactive)
  (load-file (expand-file-name "~/.emacs.d/init.el")))

;; ============================================================
;; UI
;; ============================================================

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 4)
(electric-pair-mode 1)

(setq display-line-numbers-type 'relative)
(setq use-dialog-box nil)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'yaml-ts-mode-hook #'display-line-numbers-mode)

(add-to-list 'default-frame-alist '(width  . 140))
(add-to-list 'default-frame-alist '(height . 44))

(set-face-attribute 'default nil :font "Fira Code" :height 120)

;; -- Icons --

(use-package nerd-icons
  :ensure t
  :config
  (unless (find-font (font-spec :name "Symbols Nerd Font Mono"))
    (nerd-icons-install-fonts t)))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :after nerd-icons
  :config (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package dashboard
  :ensure t
  :after nerd-icons
  :custom
  (dashboard-items '((recents . 5) (projects . 5) (agenda . 5) (bookmarks . 5)))
  (dashboard-startup-banner 2)
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)   ; <-- this
  (dashboard-set-file-icons t)      ; <-- and this
  :config
  (dashboard-setup-startup-hook)
  :init
  (setq initial-buffer-choice 'dashboard-open))

;; Theme
(load-theme 'vague t)

(defun spiperac/toggle-theme ()
  "Toggle between vague dark and light themes."
  (interactive)
  (if (custom-theme-enabled-p 'vague)
      (progn (disable-theme 'vague)       (load-theme 'vague-light t))
    (progn   (disable-theme 'vague-light) (load-theme 'vague t))))

(global-set-key (kbd "C-c t")    #'spiperac/toggle-theme)
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;; Tab bar

(tab-bar-mode 1)
(setq tab-bar-show 1
      tab-bar-close-button-show nil
      tab-bar-new-button-show nil
      tab-bar-tab-hints t
      tab-bar-auto-width nil
      tab-bar-separator " "
      tab-bar-border nil)

;; Font: same as buffer, slightly bigger
(let ((h (face-attribute 'default :height)))
  (set-face-attribute 'tab-bar nil
                      :inherit 'default
                      :height (+ h 10)
                      :box nil))

;; Faces: no dividers, only active highlighted
(set-face-attribute 'tab-bar nil
                    :background "#141415"
                    :foreground "#cdcdcd"
                    :box nil)

(set-face-attribute 'tab-bar-tab nil
                    :background "#1e1e20"
                    :foreground "#ffffff"
                    :weight 'semi-bold
                    :box nil)

(set-face-attribute 'tab-bar-tab-inactive nil
                    :background "#141415"
                    :foreground "#888888"
                    :box nil)

;; bin tabs by nubers with C-c 1..9
(dotimes (i 9)
  (let ((n (1+ i)))
    (global-set-key (kbd (format "C-c %d" n))
                    (lambda () (interactive) (tab-bar-select-tab n)))))

;; Helpers
(defun tab--buffer (tab)
  (get-buffer (alist-get 'name tab)))

(defun tab--dirty-p (tab)
  (when-let ((buf (tab--buffer tab)))
    (buffer-modified-p buf)))

(defun tab--git-dirty-p (tab)
  (when-let* ((buf (tab--buffer tab))
              (file (buffer-file-name buf)))
    (eq (vc-state file) 'edited)))

;; Formatter
(setq tab-bar-tab-name-format-function
      (lambda (tab i)
        (let* ((active (eq (car tab) 'current-tab))
               (face   (if active 'tab-bar-tab 'tab-bar-tab-inactive))
               (name   (alist-get 'name tab)))
          (concat
           " "
           (propertize name 'face face)
           (when (tab--dirty-p tab)
             (propertize " ●" 'face `(:foreground ,(if active "#ffffff" "#888888"))))
           (when (tab--git-dirty-p tab)
             (propertize " " 'face `(:foreground ,(if active "#ffffff" "#888888"))))
           " "))))

;; Evil state tags (set before evil loads)
(setq evil-normal-state-tag   (propertize "[NORMAL]")
      evil-emacs-state-tag    (propertize "[Emacs]")
      evil-insert-state-tag   (propertize "[INSERT]")
      evil-motion-state-tag   (propertize "[Motion]")
      evil-visual-state-tag   (propertize "[Visual]")
      evil-operator-state-tag (propertize "[Operator]"))

;; ============================================================
;; PACKAGES
;; ============================================================

;; -- Evil & Keybinds --

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-set-undo-system 'undo-redo)
  (evil-mode 1)
  (define-prefix-command 'my-leader-map)
  (evil-define-key 'normal 'global (kbd "SPC") 'my-leader-map)
  (define-key my-leader-map (kbd "r") #'spiperac/reload-config)
  (define-key my-leader-map (kbd "y") #'spiperac/replace-buffer-with-clipboard)
  (define-key my-leader-map (kbd "sf")  #'project-find-file)
  (define-key my-leader-map (kbd "sp")  #'project-switch-project)
  (define-key my-leader-map (kbd "sr")  #'consult-recent-file)
  (define-key my-leader-map (kbd "sq")  #'project-query-replace-regexp)
  (define-key my-leader-map (kbd "sb")  #'consult-buffer)
  (define-key my-leader-map (kbd "sg")  #'consult-git-grep)
  (define-key my-leader-map (kbd "/")   #'consult-line)
  (define-key my-leader-map (kbd "M")   #'notmuch)
  (define-key my-leader-map (kbd "i c") #'my/erc-connect)
  (define-key my-leader-map (kbd "gg")  #'magit)
  (define-key my-leader-map (kbd "gc")  #'my/git-clone)
  (define-key my-leader-map (kbd "pn")  #'my/new-project)
  (define-key my-leader-map (kbd "e")   #'dired-sidebar-toggle-sidebar)
  (define-key my-leader-map (kbd "d")   #'dashboard-open)
  (define-key my-leader-map (kbd "v")   #'evil-window-vsplit)
  (define-key my-leader-map (kbd "n")   #'evil-window-next)
  (define-key my-leader-map (kbd "q")   #'evil-window-delete)
  (define-key my-leader-map (kbd "h")   #'evil-window-split)
  (define-key my-leader-map (kbd "a a") #'org-agenda)
  (define-key my-leader-map (kbd "a t") (lambda () (interactive) (org-agenda nil "t")))
  (define-key my-leader-map (kbd "a c") #'org-capture)
  (define-key my-leader-map (kbd "o f") #'org-roam-node-find)
  (define-key my-leader-map (kbd "o t") #'org-roam-tag-add)
  (define-key my-leader-map (kbd "o i") #'org-id-get-create)
  ;; Subsonic music keybinds
  (define-key my-leader-map (kbd "m m") #'subsonic)
  (define-key my-leader-map (kbd "m s") #'subsonic-search)
  (define-key my-leader-map (kbd "m p") #'subsonic-toggle-playing)
  ;; Tabs keybinds
  (define-key my-leader-map (kbd "t n") #'tab-bar-new-tab)
  (define-key my-leader-map (kbd "t q") #'tab-bar-close-tab)
  (define-key my-leader-map (kbd "t r") #'tab-bar-rename-tab)
  (define-key my-leader-map (kbd "t k") #'tab-bar-switch-to-next-tab)
  (define-key my-leader-map (kbd "t j") #'tab-bar-switch-to-prev-tab)
  ;; LLM Keybinds
  (define-key my-leader-map (kbd "l l") #'gptel)
  (define-key my-leader-map (kbd "l s") #'gptel-send)
  (define-key my-leader-map (kbd "l r") #'gptel-rewrite)
  (define-key my-leader-map (kbd "l m") #'gptel-menu)
)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init 'magit)
  (evil-collection-init 'dired)   ;; dirvish overrides dired
  (evil-collection-init 'dashboard)
  (evil-collection-init 'notmuch))

;; -- Modeline --

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 40)
  (doom-modeline-icon t)
  (doom-modeline-modal-icon nil)
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-project-name nil)
  (doom-modeline-buffer-encoding nil)
  (line-number-mode nil)
  (column-number-mode nil)
  :config
  (set-face-attribute 'mode-line nil :height 140))

;; -- Rainbow delimiters --

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (text-mode . rainbow-delimiters-mode)))

;; -- Completion: Vertico + Orderless + Consult --

(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))

(use-package marginalia
  :init (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package consult
  :custom
  (consult-async-min-input 0)
  (consult-ripgrep-args
   "rg --hidden --glob !.git --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip"))

(use-package consult-dir
  :bind (:map minibuffer-local-map ("C-d" . consult-dir)))

(defun consult-buffer-kill ()
  (interactive)
  (let* ((candidate (substring (vertico--candidate) 0 -1))
         (buf (get-buffer candidate)))
    (when buf
      (kill-buffer buf)
      (vertico--update t))))

(define-key vertico-map (kbd "C-q") #'consult-buffer-kill)

;; -- Corfu --

(use-package corfu
  :init (global-corfu-mode)
  :bind (:map corfu-map
         ("C-n"      . corfu-next)
         ("C-p"      . corfu-previous)
         ("<escape>" . corfu-quit)
         ("<return>" . corfu-insert)
         ("<tab>"    . corfu-next)
         ("S-<tab>"  . corfu-previous))
  :custom
  (corfu-cycle t)
  (corfu-auto nil)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2)
  (corfu-quit-at-boundary nil)
  (corfu-preselect-first t)
  (corfu-want-tab-prefer-expand-snippets t)
  :config
  (with-eval-after-load 'evil
    (define-key evil-insert-state-map (kbd "C-j") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-k") #'corfu-previous)
    (define-key evil-insert-state-map (kbd "C-n") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-p") #'corfu-previous)
    )
  (define-key minibuffer-local-map (kbd "C-j") #'next-line-or-history-element)
  (define-key minibuffer-local-map (kbd "C-k") #'previous-line-or-history-element))

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil))

;; -- Cape (completion extensions) --

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; -- Which-key (built-in Emacs 30+) --

(use-package which-key
  :ensure nil
  :config (which-key-mode))

;; -- Recent files --

(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; -- History --

(savehist-mode 1)

;; -- Vterm --

(use-package vterm
  :commands vterm
  :config
  (define-key my-leader-map (kbd "s t") #'vterm))

;; -- Magit --

(use-package magit :defer t)

;; --Dired --
(use-package dired-sidebar
  :ensure t
  :commands dired-sidebar-toggle-sidebar
  :custom
  (dired-sidebar-theme 'nerd-icons)
  (dired-sidebar-use-term-integration t)
  (dired-sidebar-width 35)
  (dired-sidebar-follow-file-idle-delay 0.3)
  (dired-sidebar-follow-file-at-point-on-toggle-open t)
  (dired-sidebar-no-delete-other-windows t)
  (dired-sidebar-use-project-root t))   ;; <-- follows project.el
  (setq dired-sidebar-use-custom-font t)

;; -- Direnv --

(use-package direnv
  :config (direnv-mode))

;; -- Eglot (built-in Emacs 29+) --

(use-package eglot
  :ensure nil
  :hook ((c-mode      . eglot-ensure)
         (c++-mode    . eglot-ensure)
         (python-mode . eglot-ensure)
         (go-mode     . eglot-ensure)
         (rust-mode   . eglot-ensure)
         (php-mode    . eglot-ensure))
  :bind (:map eglot-mode-map
         ("C-c d" . xref-find-definitions)
         ("C-c r" . eglot-rename)
         ("C-c c" . eglot-code-actions)
         ("C-c k" . eldoc-box-help-at-point))
  :custom
  (eglot-server-programs
   '((c-mode             . ("clangd"))
     (c++-mode           . ("clangd"))
     (python-mode        . ("pyright-langserver" "--stdio"))
     (go-mode            . ("gopls"))
     (rust-mode          . ("rust-analyzer"))
     (typescript-ts-mode . ("typescript-language-server" "--stdio"))
     ((php-mode)         . ("phpactor" "language-server"))))
  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(use-package eldoc-box)

;; -- Pet (uv / virtualenv) --

(use-package pet
  :hook (python-mode . pet-mode))

;; -- Language modes --

(use-package nix-mode   :defer t)
(use-package go-mode    :defer t)
(use-package php-mode   :defer t)
(use-package markdown-mode :defer t)

(use-package rust-mode
  :defer t
  :custom (rust-format-on-save t))

;; -- Treesitter (treesit-auto manages grammars + mode remapping) --

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config (global-treesit-auto-mode))

;; -- Project --

(setq project-vc-extra-root-markers '(".project"))

;; -- Org --

(use-package org
  :hook (org-mode . visual-line-mode)
  :custom
  (org-default-notes-file "~/Vault/Org/agenda.org")
  (org-agenda-files '("~/Vault/Org/agenda.org"))
  (org-capture-templates '(("t" "Todo" entry (file "~/Vault/Org/agenda.org") "* TODO %?"))))
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Vault/Org")
  (org-roam-file-exclude-regexp "Blog/\\|agenda\\.org")
  (org-roam-db-location "~/.cache/emacs/org-roam.db")
  (org-roam-node-display-template
   (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :ensure t
  :after org-roam)

(use-package htmlize :defer t)
(use-package simple-httpd :defer t)

(use-package org-download
  :after org
  :hook (org-mode . org-download-enable)
  :custom
  (org-download-image-dir "./images")
  (org-download-method 'directory))

;; -- Subsonic --

(use-package subsonic
  :commands (subsonic subsonic-search)
  :custom
  (subsonic-host (string-trim (shell-command-to-string "pass subsonic/host")))
  (subsonic-ssl nil)
  (subsonic-enable-art t)
  :config
  (dolist (entry `((,subsonic-artist-mode-map     . subsonic-open-album)
                   (,subsonic-album-mode-map      . subsonic-open-tracks)
                   (,subsonic-album-type-mode-map . subsonic-open-tracks)
                   (,subsonic-tracks-mode-map     . subsonic-play-tracks)
                   (,subsonic-search-mode-map     . subsonic-open-search-result)))
    (define-key      (car entry) (kbd "RET") (cdr entry))
    (evil-define-key 'normal (car entry) (kbd "RET") (cdr entry))))

;; -- Email - Notmuch --

(require 'notmuch)
(setq user-full-name "Strahinja Piperac")
(setq user-mail-adress "strahinj@piperac.net")
(setq message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "msmtp"
      mail-specify-envelope-from t
      mail-envelope-from 'header
      )
(setq message-kill-buffer-on-exit t)
(customize-set-variable 'notmuch-search-oldest-first nil)

(defvar spiperac/unread-count "0")

(defun spiperac/update-unread-count ()
  (setq spiperac/unread-count
        (string-trim (shell-command-to-string "notmuch count tag:unread"))))

(run-at-time 0 900 (lambda ()
  (start-process "mbsync" nil "/run/current-system/sw/bin/mbsync" "-a")
  (run-at-time 30 nil (lambda ()  ; increased from 5 to 10
    (unless gptel--request-alist
      (notmuch-poll))
    (spiperac/update-unread-count)))))

(add-to-list 'mode-line-misc-info
  '(:eval (unless (string= spiperac/unread-count "0")
            (concat " ✉️ " spiperac/unread-count))))

;; -- IRC --
(require 'auth-source-pass)
(auth-source-pass-enable)

(defvar my/erc-servers
  '(("Libera"      :server "irc.libera.chat"      :port 6697 :nick "strah" :pass-path "irc/libera/strah")
    ("OverTheWire" :server "ircs.overthewire.org"  :port 6697 :nick "strah" :pass-path "irc/overthewire/strah"))
  "List of IRC servers for ERC.")

(defun my/erc-connect ()
  (interactive)
  (let* ((choice    (completing-read "Connect to IRC server: "
                                     (mapcar #'car my/erc-servers)))
         (server    (alist-get choice my/erc-servers nil nil #'equal))
         (host      (plist-get server :server))
         (port      (plist-get server :port))
         (nick      (plist-get server :nick))
         (pass-path (plist-get server :pass-path))
         (password  (auth-source-pass-get 'secret pass-path)))
    (erc-tls :server host :port port :nick nick :password password)))

;; -- LLMs --
(use-package gptel
  :config
  (setq gptel-api-key (string-trim (shell-command-to-string "pass claude/api-key")))
  (setq gptel-backend (gptel-make-anthropic "Claude" :stream t :key gptel-api-key))
  (setq gptel-model 'claude-sonnet-4-6))

;; ============================================================
;; PUBLISHING
;; ============================================================

(require 'ox-publish)
(setq org-html-htmlize-output-type 'css)

;; -- Blog --

;; Load org-grimoire from local project
(use-package org-grimoire
  :ensure t)

(defvar blog/dir "~/Vault/Org/Blog")
(setq org-export-with-sub-superscripts nil)

;; Setup
(org-grimoire-setup "strah.net"
  :base-url "https://strah.net"
  :base-dir blog/dir
  :author "sp"
  :site-title "strah.netspace"
  :description "bits and stuff"
  :theme "strah"
  :pagination t
  :reading-time t
  :per-page 8
  )

(defun blog/compress-images ()
  "Compress images in blog posts directory, skipping already compressed ones."
  (interactive)
  (let ((marker (concat blog/dir "/.compressed")))
    (shell-command
     (format
      "find %s \\( -name '*.png' -o -name '*.jpg' \\) -newer %s -print0 | xargs -0 -I{} sh -c 'magick \"$1\" -strip -resize \"1200>\" -colors 256 PNG8:/tmp/compressed_img && mv /tmp/compressed_img \"$1\"' _ {} && touch %s"
      (concat blog/dir "/content/post")
      marker
      marker))))

(defun strah/publish-prod ()
  "Publish blog and rsync to VPS."
  (interactive)
  (blog/compress-images)
  (org-grimoire-build "strah.net")
  (shell-command
   (format "rsync -avz --delete %s/ strah:/var/www/strah.net/"
           (concat blog/dir "/public_html"))))

;; -- Pentest notes --

(defun spiperac/publish-notes ()
  "Publish pentest notes."
  (interactive)
  (let ((org-html-htmlize-output-type 'css))
    (org-publish "cpts" t)))

(defun spiperac/view-notes ()
  "Serve and open pentest notes in browser."
  (interactive)
  (httpd-serve-directory "~/Vault/Org/Pentest/public_html/")
  (browse-url "http://localhost:8080"))

(dolist (project
         '(("pentest-notes"
            :base-directory "~/Vault/Org/Pentest/"
            :base-extension "org"
            :publishing-directory "~/Vault/Org/Pentest/public_html/"
            :html-head "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
            :recursive t
            :publishing-function org-html-publish-to-html
            :auto-sitemap t
            :sitemap-title "Pentest Notes"
            :html-head-include-default-style nil
            :htmlized-source t
            :with-author nil
            :html-postamble nil
            :with-creator nil
            :sitemap-filename "index.org"
            :sitemap-style list
            :exclude "public_html"
            :with-toc t)
           ("pentest-images"
            :base-directory "~/Vault/Org/Pentest/"
            :publishing-directory "~/Vault/Org/Pentest/public_html/"
            :recursive t
            :publishing-function org-publish-attachment
            :base-extension "png\\|jpg\\|jpeg\\|gif\\|svg\\|webp")
           ("cpts" :components ("pentest-notes" "pentest-images"))))
  (add-to-list 'org-publish-project-alist project))

;; ============================================================
;; CUSTOM FUNCTIONS
;; ============================================================

(defun spiperac/replace-buffer-with-clipboard ()
  "Replace entire buffer content with clipboard."
  (interactive)
  (delete-region (point-min) (point-max))
  (yank))

(defun create-note (filename)
  "Create and open a new note in ~/Vault/notes/."
  (interactive "sNote name: ")
  (find-file (concat (expand-file-name "~/Vault/notes/")
                     (if (string-match-p "\\." filename)
                         filename
                       (concat filename ".md")))))

(defun my/new-project ()
  "Create a new project directory with a .project marker."
  (interactive)
  (let ((dir (read-directory-name "New project directory: ")))
    (make-directory dir t)
    (write-region "" nil (expand-file-name ".project" dir))
    (project-switch-project dir)))

(defun my/git-clone ()
  "Clone a git repo into ~/projects/."
  (interactive)
  (let* ((url  (read-string "Git repo URL: "))
         (name (file-name-base (string-trim-right url "\\.git")))
         (dir  (expand-file-name name "~/projects")))
    (shell-command (format "git clone %s %s" url dir))
    (project-switch-project dir)))

;; PHP symref patterns
(with-eval-after-load 'semantic/symref
  (add-to-list 'semantic-symref-filepattern-alist
               '(php-mode "*.php" "*.phtml" "*.php5" "*.php7")))

(defun insert-src-block ()
  (interactive)
  (insert "#+BEGIN_SRC \n\n#+END_SRC")
  (forward-line -2)
  (end-of-line))

(define-key org-mode-map (kbd "C-c s") 'insert-src-block)

;;; init.el ends here

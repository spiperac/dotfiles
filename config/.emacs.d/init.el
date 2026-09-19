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
      save-place-file              (expand-file-name "places" my-cache-dir)
      recentf-save-file            (expand-file-name "recentf" my-cache-dir)
      savehist-file                (expand-file-name "history" my-cache-dir)
      ielm-history-file-name       (expand-file-name "ielm-history.eld" my-cache-dir)
      org-id-locations-file        (expand-file-name "org-id-locations" my-cache-dir)
      tramp-persistency-file-name  (expand-file-name "tramp" my-cache-dir)
      transient-history-file       (expand-file-name "transient/history.el" my-cache-dir)
      transient-levels-file        (expand-file-name "transient/levels.el" my-cache-dir)
      transient-values-file        (expand-file-name "transient/values.el" my-cache-dir)
      url-configuration-directory  (expand-file-name "url/" my-cache-dir)
      eshell-directory-name        (expand-file-name "eshell/" my-cache-dir)
      project-list-file            (expand-file-name "projects.eld" my-cache-dir))

;; Native comp cache (eln-cache)

(if (and (fboundp 'startup-redirect-eln-cache)
         (boundp 'native-comp-eln-load-path))
    (startup-redirect-eln-cache (expand-file-name "eln-cache/" my-cache-dir)))
;; ============================================================
;; ENCODING
;; ============================================================

(prefer-coding-system 'utf-8)
(set-language-environment "English")

;; ============================================================
;; CUSTOM FILE
;; ============================================================

(make-directory my-cache-dir t)
(unless (file-exists-p custom-file) (write-region "" nil custom-file))
(load custom-file :noerror)

;; ============================================================
;; PACKAGE BOOTSTRAP
;; ============================================================

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-compute-statistics t)

;; ============================================================
;; CORE SETTINGS
;; ============================================================

(setq auto-revert-avoid-polling t)
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
      read-process-output-max (* 1024 1024)
      )
(save-place-mode 1) ;; remmembers cursor possition in a file even after closing

;; No sound
(setq visible-bell t)
(setq ring-bell-function 'ignore)

(defun strah/sync-frame-decoration ()
  "Undecorate the frame while fullscreen, decorate it otherwise."
  (let ((want (and (frame-parameter nil 'fullscreen) t)))
    (unless (eq want (and (frame-parameter nil 'undecorated) t))
      (set-frame-parameter nil 'undecorated want))))

(add-hook 'window-state-change-hook #'strah/sync-frame-decoration)

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
(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" my-cache-dir))))

;; PATH
(defun strah/add-to-path (path)
  "Add PATH to `exec-path' and $PATH."
  (add-to-list 'exec-path (expand-file-name path))
  (setenv "PATH" (string-join exec-path ":")))

(mapc #'strah/add-to-path
      '("~/.local/bin"
        "~/.composer/vendor/bin"))

(defun strah/reload-config ()
  "Reload init.el configuration."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory)))

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

(when (find-font (font-spec :name "Fira Code"))
  (set-face-attribute 'default nil :font "Fira Code" :height 120))

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
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  :config
  (dashboard-setup-startup-hook)
  :init
  (setq initial-buffer-choice 'dashboard-open))

;; Theme
(use-package srcery-theme
  :ensure t
  :config
  (load-theme 'srcery t))

(defun strah/toggle-theme ()
  "Toggle between srcery and modus-operandi-tinted."
  (interactive)
  (if (custom-theme-enabled-p 'srcery)
      (progn (disable-theme 'srcery)                  (load-theme 'modus-operandi-tinted t))
    (progn   (disable-theme 'modus-operandi-tinted)   (load-theme 'srcery t))))

(global-set-key (kbd "C-c t")    #'strah/toggle-theme)
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

(set-face-attribute 'tab-bar nil
                    :inherit 'default
                    :height (+ (face-attribute 'default :height) 10)
                    :box nil)

(set-face-attribute 'tab-bar-tab nil
                    :inherit 'mode-line
                    :weight 'semi-bold
                    :box nil)

(set-face-attribute 'tab-bar-tab-inactive nil
                    :inherit 'mode-line-inactive
                    :box nil)

;; bin tabs by nubers with C-c 1..9
(dotimes (i 9)
  (let ((n (1+ i)))
    (global-set-key (kbd (format "C-c %d" n))
                    (lambda () (interactive) (tab-bar-select-tab n)))))

;; Helpers
(defun strah/tab-buffer (tab)
  (get-buffer (alist-get 'name tab)))

(defun strah/tab-dirty-p (tab)
  (when-let ((buf (strah/tab-buffer tab)))
    (buffer-modified-p buf)))

(defun strah/tab-git-dirty-p (tab)
  (when-let* ((buf (strah/tab-buffer tab))
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
           (when (strah/tab-dirty-p tab)
             (propertize " ●" 'face face))
           (when (strah/tab-git-dirty-p tab)
             (propertize " " 'face face))
           " "))))

;; Evil state tags (set before evil loads)
(setq evil-normal-state-tag   "[NORMAL]"
      evil-emacs-state-tag    "[Emacs]"
      evil-insert-state-tag   "[INSERT]"
      evil-motion-state-tag   "[Motion]"
      evil-visual-state-tag   "[Visual]"
      evil-operator-state-tag "[Operator]")

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
  (define-key my-leader-map (kbd "r") #'strah/reload-config)
  (define-key my-leader-map (kbd "y") #'strah/replace-buffer-with-clipboard)
  (define-key my-leader-map (kbd "sf")  #'project-find-file)
  (define-key my-leader-map (kbd "sp")  #'project-switch-project)
  (define-key my-leader-map (kbd "sr")  #'consult-recent-file)
  (define-key my-leader-map (kbd "sq")  #'project-query-replace-regexp)
  (define-key my-leader-map (kbd "sb")  #'consult-buffer)
  (define-key my-leader-map (kbd "b")   #'consult-buffer)
  (define-key my-leader-map (kbd "sg")  #'consult-git-grep)
  (define-key my-leader-map (kbd "/")   #'consult-line)
  (define-key my-leader-map (kbd "gg")  #'magit)
  (define-key my-leader-map (kbd "gc")  #'strah/git-clone)
  (define-key my-leader-map (kbd "pn")  #'strah/new-project)
  (define-key my-leader-map (kbd "e")   #'dired-sidebar-toggle-sidebar)
  (define-key my-leader-map (kbd "d")   #'dashboard-open)
  (define-key my-leader-map (kbd "v")   #'evil-window-vsplit)
  (define-key my-leader-map (kbd "o")   #'evil-window-next)
  (define-key my-leader-map (kbd "q")   #'evil-window-delete)
  (define-key my-leader-map (kbd "h")   #'evil-window-split)
  (define-key my-leader-map (kbd "a a") #'org-agenda)
  (define-key my-leader-map (kbd "a t") (lambda () (interactive) (org-agenda nil "t")))
  (define-key my-leader-map (kbd "a c") #'org-capture)
  ;; Tabs keybinds
  (define-key my-leader-map (kbd "t n") #'tab-bar-new-tab)
  (define-key my-leader-map (kbd "t q") #'tab-bar-close-tab)
  (define-key my-leader-map (kbd "t r") #'tab-bar-rename-tab)
  (define-key my-leader-map (kbd "t k") #'tab-bar-switch-to-next-tab)
  (define-key my-leader-map (kbd "t j") #'tab-bar-switch-to-prev-tab)
  ;; Kubernetes keybinds
  (define-key my-leader-map (kbd "k k") #'kubernetes-overview)
  (define-key my-leader-map (kbd "k n") #'kubernetes-set-namespace)
  (define-key my-leader-map (kbd "k l") #'kubernetes-logs-follow)
  (define-key my-leader-map (kbd "k e") #'kubernetes-exec-into)
  (define-key my-leader-map (kbd "k d") #'kubernetes-describe-dwim)
  ;; LLM Keybinds
  (define-key my-leader-map (kbd "l l") #'agent-shell-anthropic-start-claude-code)
  (define-key my-leader-map (kbd "l n") #'agent-shell-new-shell)
  (define-key my-leader-map (kbd "l w") #'agent-shell-new-worktree-shell)
  (define-key my-leader-map (kbd "l r") #'agent-shell-send-region-to)
  (define-key my-leader-map (kbd "l f") #'agent-shell-send-file)
  (define-key my-leader-map (kbd "l t") #'agent-shell-toggle))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init 'magit)
  (evil-collection-init 'dired)
  (evil-collection-init 'dashboard))

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
  (consult-async-min-input 2)
  (consult-ripgrep-args
   "rg --hidden --glob !.git --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip"))

(use-package consult-dir
  :bind (:map minibuffer-local-map ("C-d" . consult-dir)))

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
  (corfu-preselect 'first)
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
  (dired-sidebar-use-project-root t)   ;; <-- follows project.el
  (dired-sidebar-use-custom-font t))

;; -- Direnv --

(use-package direnv
  :config (direnv-mode))

;; -- Eglot (built-in Emacs 29+) --

(use-package eglot
  :ensure nil
  :hook (((c-mode c-ts-mode)           . eglot-ensure)
         ((c++-mode c++-ts-mode)       . eglot-ensure)
         ((python-mode python-ts-mode) . eglot-ensure)
         ((go-mode go-ts-mode)         . eglot-ensure)
         ((rust-mode rust-ts-mode)     . eglot-ensure)
         ((php-mode php-ts-mode)       . eglot-ensure)
         (terraform-mode               . eglot-ensure))
  :bind (:map eglot-mode-map
         ("C-c d" . xref-find-definitions)
         ("C-c r" . eglot-rename)
         ("C-c c" . eglot-code-actions)
         ("C-c k" . eldoc-box-help-at-point))
  :config
  ;; Eglot defaults already use clangd, gopls, rust-analyzer, ts-ls and phpactor
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio")))
  (add-hook 'eglot-managed-mode-hook
            (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(use-package eldoc-box :commands eldoc-box-help-at-point)

;; -- Pet (uv / virtualenv) --

(use-package pet
  :hook ((python-mode python-ts-mode) . pet-mode))

;; -- Language modes --

(use-package nix-mode      :defer t)
(use-package markdown-mode :defer t)

;; -- Terraform --

(use-package terraform-mode :defer t)

;; -- Ansible --

(use-package ansible
  :hook (yaml-ts-mode . ansible))

(use-package ansible-doc
  :commands ansible-doc
  :hook (ansible . ansible-doc-mode))

(use-package jinja2-mode
  :mode "\\.j2\\'")

;; -- Treesitter (built-in Emacs 31+) --

(setopt treesit-auto-install-grammar 'ask
        treesit-enabled-modes t)

;; -- Project --

(setq project-vc-extra-root-markers '(".project"))

;; -- Kubernetes --

(use-package kubernetes
  :commands (kubernetes-overview
             kubernetes-display-pod
             kubernetes-exec-into
             kubernetes-logs-follow
             kubernetes-describe-dwim
             kubernetes-set-namespace)
  :custom
  (kubernetes-poll-frequency 5)
  (kubernetes-redraw-frequency 5))

(use-package kubernetes-evil
  :after (kubernetes evil))

;; -- Org --

(use-package org
  :hook (org-mode . visual-line-mode)
  :bind (:map org-mode-map ("C-c s" . strah/insert-src-block)))

(use-package htmlize :defer t)
(use-package simple-httpd :defer t)

(use-package org-download
  :after org
  :hook (org-mode . org-download-enable)
  :custom
  (org-download-image-dir "./images")
  (org-download-method 'directory))

;; -- LLMs --

(use-package agent-shell
  :commands (agent-shell
             agent-shell-toggle
             agent-shell-new-shell
             agent-shell-new-worktree-shell
             agent-shell-send-region-to
             agent-shell-send-file
             agent-shell-anthropic-start-claude-code)
  :config
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t)
        shell-maker-root-path (expand-file-name "shell-maker/" my-cache-dir)
        agent-shell-dot-subdir-function
        (lambda (subdir)
          (expand-file-name subdir
                            (expand-file-name (file-name-nondirectory
                                               (directory-file-name (agent-shell-cwd)))
                                              (expand-file-name "agent-shell/" my-cache-dir))))))

;; ============================================================
;; PUBLISHING
;; ============================================================

(require 'ox-publish)
(setq org-html-htmlize-output-type 'css)

;; -- Blog --

(use-package org-grimoire
  :ensure t)

(defvar strah/blog-dir "~/code/blog")
(setq org-export-with-sub-superscripts nil)

;; Setup
(org-grimoire-setup "strah.net"
  :base-url "https://strah.net"
  :base-dir strah/blog-dir
  :author "sp"
  :site-title "strah.netspace"
  :description "bits and stuff"
  :theme "srcery"
  :pagination t
  :reading-time t
  :per-page 8
  :index-exclude-tags '("ctf")
  )

(defun strah/compress-images ()
  "Compress images in blog posts directory, skipping already compressed ones."
  (interactive)
  (let ((marker (expand-file-name ".compressed" strah/blog-dir)))
    (unless (file-exists-p marker)
      (write-region "" nil marker)
      (set-file-times marker 0))
    (shell-command
     (format
      "find %s \\( -name '*.png' -o -name '*.jpg' \\) -newer %s -print0 | xargs -0 -I{} sh -c 'magick \"$1\" -strip -resize \"1200>\" -colors 256 PNG8:/tmp/compressed_img && mv /tmp/compressed_img \"$1\"' _ {} && touch %s"
      (expand-file-name "content/post" strah/blog-dir)
      marker
      marker))))

(defun strah/publish-prod ()
  "Publish blog and rsync to VPS."
  (interactive)
  (strah/compress-images)
  (org-grimoire-build "strah.net")
  (shell-command
   (format "rsync -avz --delete %s/ strah:/var/www/strah.net/"
           (expand-file-name "public_html" strah/blog-dir))))

;; ============================================================
;; IRC
;; ============================================================

(use-package erc
  :ensure nil
  :custom
  (erc-nick '("strah" "strah_" "strah__"))
  (erc-user-full-name "strah")
  (erc-email-userid "strah")
  (erc-modules '(autojoin button completion fill imenu irccontrols
                 keep-place list match menu move-to-prompt netsplit
                 networks nicks noncommands notifications readonly
                 ring sasl scrolltobottom stamp track))
  ;; Auth: SASL EXTERNAL with client cert
  (erc-sasl-mechanism 'external)
  ;; Layout: nicks in the margin, text wraps cleanly
  (erc-fill-function #'erc-fill-wrap)
  (erc-fill-static-center 18)
  ;; Quiet: hide joins/parts from people who haven't spoken lately
  (erc-lurker-hide-list '("JOIN" "PART" "QUIT" "NICK"))
  (erc-lurker-threshold-time 3600)
  (erc-track-exclude-types '("JOIN" "PART" "QUIT" "NICK" "MODE" "333" "353"))
  ;; Buffers
  (erc-buffer-display 'bury)
  (erc-kill-buffer-on-part t)
  (erc-kill-queries-on-quit t)
  (erc-kill-server-buffer-on-quit t)
  ;; Reconnect
  (erc-server-reconnect-attempts t)
  (erc-server-reconnect-timeout 30)
  ;; Channels
  (erc-autojoin-channels-alist
   '(("libera.chat" "##infosec"))))

(defvar strah/irc-cert "~/.ssh/irc.pem")

(defun strah/irc-libera ()
  "Connect to Libera.Chat."
  (interactive)
  (erc-tls :server "irc.libera.chat" :port 6697
           :client-certificate (list (expand-file-name strah/irc-cert)
                                     (expand-file-name strah/irc-cert))))

;; ============================================================
;; CUSTOM FUNCTIONS
;; ============================================================

(defun strah/replace-buffer-with-clipboard ()
  "Replace entire buffer content with clipboard."
  (interactive)
  (delete-region (point-min) (point-max))
  (yank))

(defun strah/new-project ()
  "Create a new project directory with a .project marker."
  (interactive)
  (let ((dir (read-directory-name "New project directory: ")))
    (make-directory dir t)
    (write-region "" nil (expand-file-name ".project" dir))
    (project-switch-project dir)))

(defun strah/git-clone ()
  "Clone a git repo into ~/code/."
  (interactive)
  (let* ((url  (read-string "Git repo URL: "))
         (name (file-name-base (string-trim-right url "\\.git")))
         (dir  (expand-file-name name "~/code")))
    (shell-command (format "git clone %s %s"
                           (shell-quote-argument url)
                           (shell-quote-argument dir)))
    (project-switch-project dir)))

;; PHP symref patterns
(with-eval-after-load 'semantic/symref
  (add-to-list 'semantic-symref-filepattern-alist
               '(php-mode "*.php" "*.phtml" "*.php5" "*.php7")))

(defun strah/insert-src-block ()
  "Insert an empty Org source block and move point inside it."
  (interactive)
  (insert "#+BEGIN_SRC \n\n#+END_SRC")
  (forward-line -2)
  (end-of-line))

;;; init.el ends here

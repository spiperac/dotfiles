;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-
;; Author: spiperac <spiperac@denkei.org>
;; URL: https://spiperac.dev/
;;; Code:

;;; Server

(require 'server)
(unless (server-running-p)
  (server-start))

;;; Paths

(defvar strah/cache-directory "~/.cache/emacs/")
(make-directory strah/cache-directory t)

(setq bookmark-default-file       (expand-file-name "bookmarks" strah/cache-directory)
      custom-file                 (expand-file-name "custom.el" strah/cache-directory)
      save-place-file             (expand-file-name "places" strah/cache-directory)
      recentf-save-file           (expand-file-name "recentf" strah/cache-directory)
      savehist-file               (expand-file-name "history" strah/cache-directory)
      ielm-history-file-name      (expand-file-name "ielm-history.eld" strah/cache-directory)
      org-id-locations-file       (expand-file-name "org-id-locations" strah/cache-directory)
      transient-history-file      (expand-file-name "transient/history.el" strah/cache-directory)
      transient-levels-file       (expand-file-name "transient/levels.el" strah/cache-directory)
      transient-values-file       (expand-file-name "transient/values.el" strah/cache-directory)
      url-configuration-directory (expand-file-name "url/" strah/cache-directory)
      eshell-directory-name       (expand-file-name "eshell/" strah/cache-directory)
      project-list-file           (expand-file-name "projects.eld" strah/cache-directory)
      backup-directory-alist      `(("." . ,(expand-file-name "backups/" strah/cache-directory))))

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache (expand-file-name "eln-cache/" strah/cache-directory)))

(load custom-file :noerror)

;;; Packages

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t)

;;; Core

(prefer-coding-system 'utf-8)
(set-language-environment "English")

(setq select-enable-primary t
      create-lockfiles nil
      auto-save-default nil
      use-short-answers t
      initial-scratch-message ""
      read-process-output-max (* 1024 1024)
      ring-bell-function 'ignore
      tab-always-indent 'complete
      auto-revert-avoid-polling t
      recentf-max-saved-items 50
      project-vc-extra-root-markers '(".project")
      scroll-conservatively 101
      scroll-step 1
      scroll-preserve-screen-position 1
      auto-window-vscroll nil)

(setq-default indent-tabs-mode nil
              tab-width 4)

(global-auto-revert-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(electric-pair-mode 1)
(pixel-scroll-precision-mode 1)

(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

(add-to-list 'exec-path (expand-file-name "~/.local/bin"))
(setenv "PATH" (string-join exec-path path-separator))

(defun strah/reload-config ()
  "Reload init.el configuration."
  (interactive)
  (load-file user-init-file))

;;; UI

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 4)

(setq frame-title-format nil
      frame-resize-pixelwise t
      use-dialog-box nil
      display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(width . 140))
(add-to-list 'default-frame-alist '(height . 44))
(add-to-list 'default-frame-alist '(font . "Fira Code-12"))

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'yaml-ts-mode-hook #'display-line-numbers-mode)

(add-hook 'window-size-change-functions #'frame-hide-title-bar-when-maximized)

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (text-mode . rainbow-delimiters-mode)))

(use-package srcery-theme
  :config
  (load-theme 'srcery t))

(defun strah/toggle-theme ()
  "Toggle between srcery and modus-operandi-tinted."
  (interactive)
  (if (custom-theme-enabled-p 'srcery)
      (progn
        (disable-theme 'srcery)
        (load-theme 'modus-operandi-tinted t))
    (disable-theme 'modus-operandi-tinted)
    (load-theme 'srcery t)))

(global-set-key (kbd "C-c t") #'strah/toggle-theme)

(use-package nerd-icons
  :config
  (unless (or (daemonp)
              (find-font (font-spec :name "Symbols Nerd Font Mono")))
    (nerd-icons-install-fonts t)))

;;; Mode line

(defun strah/mode-line-faces (&rest _)
  "Pad the mode line vertically."
  (dolist (face '(mode-line mode-line-inactive))
    (set-face-attribute face nil :box '(:line-width (1 . 8) :style flat-button))))

(strah/mode-line-faces)
(add-hook 'enable-theme-functions #'strah/mode-line-faces)

(defun strah/mode-line-buffer ()
  "Return the buffer icon, name and modified mark."
  (concat (nerd-icons-icon-for-mode major-mode)
          " "
          (propertize (buffer-name) 'face 'mode-line-buffer-id)
          (when (and buffer-file-name (buffer-modified-p))
            (propertize " ●" 'face 'error))))

(setq vc-display-status 'no-backend
      auto-revert-check-vc-info t)

(defvar strah/git-unpushed-commits (make-hash-table :test #'equal)
  "Number of unpushed commits for each repository root.")

(defvar-local strah/git-root nil
  "Root of the git repository of the current buffer.")

(defun strah/git-count-unpushed-commits ()
  "Count the unpushed commits of the current repository in the background."
  (setq strah/git-root
        (when-let* ((root (locate-dominating-file default-directory ".git")))
          (expand-file-name root)))
  (when-let* ((root strah/git-root)
              (process-name (concat "git-unpushed " root))
              ((not (get-process process-name))))
    (let ((default-directory root)
          (output (generate-new-buffer " *git-unpushed*")))
      (make-process
       :name process-name
       :buffer output
       :command '("git" "rev-list" "--count" "@{upstream}..HEAD")
       :noquery t
       :sentinel
       (lambda (process _event)
         (unless (process-live-p process)
           (puthash root
                    (if (zerop (process-exit-status process))
                        (string-to-number (with-current-buffer output (buffer-string)))
                      0)
                    strah/git-unpushed-commits)
           (kill-buffer output)
           (force-mode-line-update t)))))))

(add-hook 'find-file-hook #'strah/git-count-unpushed-commits)

(defun strah/mode-line-vc ()
  "Return the branch: green when committed, red when changed, yellow when unpushed."
  (when (and vc-mode buffer-file-name)
    (propertize (concat " " (string-trim-left (substring-no-properties vc-mode) " *[-:@!?]") " ")
                'face (cond ((not (eq (vc-state buffer-file-name) 'up-to-date)) 'error)
                            ((> (gethash strah/git-root strah/git-unpushed-commits 0) 0) 'warning)
                            (t 'success)))))

(setq-default mode-line-format
              '((:eval evil-mode-line-tag)
                " "
                (:eval (strah/mode-line-buffer))
                " %p"
                mode-line-format-right-align
                mode-line-misc-info
                (:eval (strah/mode-line-vc))))

;;; Tab bar

(defun strah/tab-name ()
  "Name the tab after the project of a file buffer, or the buffer name."
  (let ((buffer (window-buffer (minibuffer-selected-window))))
    (or (with-current-buffer buffer
          (when-let* ((buffer-file-name)
                      (project (project-current)))
            (project-name project)))
        (buffer-name buffer))))

(defun strah/tab-bar-faces (&rest _)
  "Style the tab bar to match the mode line."
  (set-face-attribute 'tab-bar nil
                      :inherit 'mode-line-inactive
                      :background 'unspecified
                      :foreground 'unspecified
                      :height (face-attribute 'default :height)
                      :box '(:line-width (1 . 6) :style flat-button))
  (set-face-attribute 'tab-bar-tab nil
                      :inherit 'default
                      :background 'unspecified
                      :foreground 'unspecified
                      :height 'unspecified
                      :weight 'bold
                      :underline nil
                      :box '(:line-width (1 . 6) :style flat-button))
  (set-face-attribute 'tab-bar-tab-inactive nil
                      :inherit '(shadow tab-bar)
                      :background 'unspecified
                      :foreground 'unspecified
                      :weight 'normal
                      :underline nil
                      :box 'unspecified))

(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
  (tab-bar-separator "")
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-auto-width nil)
  (tab-bar-tab-name-function #'strah/tab-name)
  (tab-bar-tab-name-format-function
   (lambda (tab _i)
     (propertize (concat "   " (alist-get 'name tab) "   ")
                 'face (funcall tab-bar-tab-face-function tab))))
  :config
  (strah/tab-bar-faces)
  (add-hook 'enable-theme-functions #'strah/tab-bar-faces)
  (tab-bar-mode 1))

;;; Evil

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-split-window-below t
        evil-vsplit-window-right t
        evil-mode-line-format nil)
  (setq evil-normal-state-tag   (propertize " NORMAL " 'face '(:inherit font-lock-function-name-face :inverse-video t :weight bold))
        evil-insert-state-tag   (propertize " INSERT " 'face '(:inherit success :inverse-video t :weight bold))
        evil-visual-state-tag   (propertize " VISUAL " 'face '(:inherit warning :inverse-video t :weight bold))
        evil-replace-state-tag  (propertize " REPLACE " 'face '(:inherit error :inverse-video t :weight bold))
        evil-operator-state-tag (propertize " OPERATOR " 'face '(:inherit error :inverse-video t :weight bold))
        evil-motion-state-tag   (propertize " MOTION " 'face '(:inherit font-lock-constant-face :inverse-video t :weight bold))
        evil-emacs-state-tag    (propertize " EMACS " 'face '(:inherit font-lock-keyword-face :inverse-video t :weight bold)))
  :config
  (evil-set-undo-system 'undo-redo)
  (evil-mode 1)
  (evil-define-key 'normal 'global (kbd "SPC")
    (define-keymap
      "r"   #'strah/reload-config
      "y"   #'strah/replace-buffer-with-clipboard
      "b"   #'consult-buffer
      "/"   #'consult-line
      "e"   #'birch
      "v"   #'evil-window-vsplit
      "h"   #'evil-window-split
      "o"   #'evil-window-next
      "q"   #'evil-window-delete
      "s f" #'project-find-file
      "s p" #'project-switch-project
      "s r" #'consult-recent-file
      "s q" #'project-query-replace-regexp
      "s b" #'consult-buffer
      "s g" #'consult-git-grep
      "g g" #'magit
      "p n" #'strah/new-project
      "a a" #'org-agenda
      "a t" (lambda () (interactive) (org-agenda nil "t"))
      "a c" #'org-capture
      "t n" #'tab-bar-new-tab
      "t q" #'tab-bar-close-tab
      "t r" #'tab-bar-rename-tab
      "t k" #'tab-bar-switch-to-next-tab
      "t j" #'tab-bar-switch-to-prev-tab
      "l l" #'agent-shell-anthropic-start-claude-code
      "l n" #'agent-shell-new-shell
      "l w" #'agent-shell-new-worktree-shell
      "l r" #'agent-shell-send-region-to
      "l f" #'agent-shell-send-file
      "l t" #'agent-shell-toggle)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init 'magit))

;;; Completion

(use-package minibuffer
  :ensure nil
  :hook (completion-list-mode . (lambda () (setq mode-line-format nil)))
  :custom
  (completion-eager-display t)
  (completion-eager-update t)
  (completion-show-help nil)
  (completions-header-format nil)
  (completions-format 'one-column)
  (completions-max-height 14)
  (completion-auto-select t)
  (completions-sort 'historical)
  (completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (minibuffer-visible-completions 'up-down)
  :bind (:map minibuffer-visible-completions-up-down-map
         ("C-j" . minibuffer-next-completion)
         ("C-k" . minibuffer-previous-completion)
         :map minibuffer-local-map
         ("C-j" . next-line-or-history-element)
         ("C-k" . previous-line-or-history-element))
  :config
  (keymap-unset minibuffer-local-completion-map "SPC"))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion orderless)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package nerd-icons-completion
  :after nerd-icons
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package consult
  :custom
  (consult-async-min-input 2)
  (consult-ripgrep-args
   "rg --hidden --glob !.git --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip"))

(use-package consult-dir
  :bind (:map minibuffer-local-map ("C-d" . consult-dir)))

(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-quit-at-boundary nil)
  (corfu-preselect 'first)
  :bind (:map corfu-map
         ("C-n"      . corfu-next)
         ("C-p"      . corfu-previous)
         ("<escape>" . corfu-quit)
         ("<return>" . corfu-insert)
         ("<tab>"    . corfu-next)
         ("S-<tab>"  . corfu-previous))
  :config
  (with-eval-after-load 'evil
    (define-key evil-insert-state-map (kbd "C-j") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-k") #'corfu-previous)
    (define-key evil-insert-state-map (kbd "C-n") #'corfu-next)
    (define-key evil-insert-state-map (kbd "C-p") #'corfu-previous)))

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;;; Tools

(use-package which-key
  :ensure nil
  :config
  (which-key-mode)
  (which-key-add-key-based-replacements
    "SPC s" "search"
    "SPC g" "git"
    "SPC p" "project"
    "SPC a" "agenda"
    "SPC t" "tabs"
    "SPC l" "llm"))

(use-package magit
  :defer t
  :config
  (add-hook 'magit-post-refresh-hook #'strah/git-count-unpushed-commits))

(use-package birch
  :ensure nil
  :load-path "~/code/birch/"
  :commands birch)

(use-package envrc
  :hook (after-init . envrc-global-mode))

;;; Programming

(use-package eglot
  :ensure nil
  :hook (((c-mode c-ts-mode)           . eglot-ensure)
         ((c++-mode c++-ts-mode)       . eglot-ensure)
         ((python-mode python-ts-mode) . eglot-ensure)
         ((go-mode go-ts-mode)         . eglot-ensure)
         ((rust-mode rust-ts-mode)     . eglot-ensure)
         (terraform-mode               . eglot-ensure))
  :bind (:map eglot-mode-map
         ("C-c d" . xref-find-definitions)
         ("C-c r" . eglot-rename)
         ("C-c c" . eglot-code-actions)
         ("C-c k" . eldoc-box-help-at-point))
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio")))
  (add-hook 'eglot-managed-mode-hook
            (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(use-package eldoc-box :commands eldoc-box-help-at-point)

(use-package pet
  :hook ((python-mode python-ts-mode) . pet-mode))

(setopt treesit-auto-install-grammar 'ask
        treesit-enabled-modes t)

(use-package nix-mode       :defer t)
(use-package markdown-mode  :defer t)
(use-package terraform-mode :defer t)
(use-package jinja2-mode    :mode "\\.j2\\'")

;;; Org

(setq calendar-week-start-day 1)

(advice-add 'org-element-parse-buffer :before
            (lambda (&rest _) (setq-local tab-width 8)))

(use-package org
  :hook (org-mode . visual-line-mode)
  :custom
  (org-directory "~/org/")
  (org-default-notes-file (expand-file-name "agenda.org" org-directory))
  (org-agenda-files (list org-directory))
  (org-agenda-skip-unavailable-files t)
  (org-capture-templates '(("t" "Todo" entry (file org-default-notes-file) "* TODO %?")))
  :config
  (make-directory org-directory t))

(use-package org-download
  :after org
  :hook (org-mode . org-download-enable)
  :custom
  (org-download-image-dir "./images")
  (org-download-method 'directory))

(defun strah/open-agenda ()
  "Show the Org agenda and return its buffer."
  (org-agenda-list)
  (get-buffer org-agenda-buffer-name))

(setq initial-buffer-choice #'strah/open-agenda)

;;; Publishing

(require 'ox-publish)
(setq org-html-htmlize-output-type 'css
      org-export-with-sub-superscripts nil)

(use-package htmlize :defer t)
(use-package simple-httpd :defer t)

(use-package org-grimoire
  ;;:ensure t
  :load-path "~/code/org-grimoire/"
  )

(defvar strah/blog-dir "~/code/blog")

(org-grimoire-setup "strah.net"
  :base-url "https://strah.net"
  :base-dir strah/blog-dir
  :author "sp"
  :site-title "strah.netspace"
  :description "bits and stuff"
  :theme "phosphor"
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

;;; LLM

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
        shell-maker-root-path (expand-file-name "shell-maker/" strah/cache-directory)
        agent-shell-dot-subdir-function
        (lambda (subdir)
          (expand-file-name subdir
                            (expand-file-name (file-name-nondirectory
                                               (directory-file-name (agent-shell-cwd)))
                                              (expand-file-name "agent-shell/" strah/cache-directory))))))

;;; Custom functions

(defun strah/replace-buffer-with-clipboard ()
  "Replace entire buffer content with clipboard."
  (interactive)
  (erase-buffer)
  (yank))

(defun strah/new-project ()
  "Create a new project directory with a .project marker."
  (interactive)
  (let ((dir (read-directory-name "New project directory: ")))
    (make-directory dir t)
    (write-region "" nil (expand-file-name ".project" dir))
    (project-switch-project dir)))

;;; init.el ends here

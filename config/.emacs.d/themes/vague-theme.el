;;; vague-theme.el --- A cool, dark, low contrast colorscheme for Emacs -*- lexical-binding: t; -*-

;; Author: spiperac
;; Based on URL: https://github.com/vague-theme/vague.nvim
;; Version: 1.0.0
;; Package-Requires: ((emacs "24.1"))

;;; Commentary:
;; Port of the vague.nvim theme for Emacs
;; A cool, dark, low contrast colorscheme. Pastel yet vivid, like a fleeting memory.

;;; Code:

(deftheme vague "A cool, dark, low contrast colorscheme")

(let ((class '((class color) (min-colors 89)))
      ;; Color palette from vague.nvim
      (bg "#141415")
      (inactive-bg "#1c1c24")
      (fg "#cdcdcd")
      (float-border "#878787")
      (line "#252530")
      (comment "#606079")
      (builtin "#b4d4cf")
      (func "#c48282")
      (string "#e8b589")
      (number "#e0a363")
      (property "#c3c3d5")
      (constant "#aeaed1")
      (parameter "#bb9dbd")
      (visual "#333738")
      (error "#d8647e")
      (warning "#f3be7c")
      (hint "#7e98e8")
      (operator "#90a0b5")
      (keyword "#6e94b2")
      (type "#9bb4bc")
      (search "#405065")
      (plus "#7fa563")
      (delta "#f3be7c"))

  (custom-theme-set-faces
   'vague

   ;; Base faces
   `(default ((,class (:foreground ,fg :background ,bg))))
   `(cursor ((,class (:background ,fg))))
   `(region ((,class (:background ,visual))))
   `(highlight ((,class (:background ,line))))
   `(hl-line ((,class (:background ,line))))
   `(fringe ((,class (:background ,bg :foreground ,comment))))
   `(shadow ((,class (:foreground ,comment))))
   `(minibuffer-prompt ((,class (:foreground ,keyword :weight bold))))
   `(vertical-border ((,class (:foreground ,float-border))))
   `(link ((,class (:foreground ,keyword :underline t))))
   `(link-visited ((,class (:foreground ,parameter :underline t))))

   ;; Font lock faces
   `(font-lock-builtin-face ((,class (:foreground ,func))))
   `(font-lock-comment-face ((,class (:foreground ,comment :slant italic))))
   `(font-lock-comment-delimiter-face ((,class (:foreground ,comment :slant italic))))
   `(font-lock-constant-face ((,class (:foreground ,constant :weight bold))))
   `(font-lock-doc-face ((,class (:foreground ,comment :slant italic))))
   `(font-lock-function-name-face ((,class (:foreground ,func))))
   `(font-lock-keyword-face ((,class (:foreground ,keyword))))
   `(font-lock-string-face ((,class (:foreground ,string :slant italic))))
   `(font-lock-type-face ((,class (:foreground ,type))))
   `(font-lock-variable-name-face ((,class (:foreground ,property))))
   `(font-lock-warning-face ((,class (:foreground ,warning :weight bold))))
   `(font-lock-negation-char-face ((,class (:foreground ,operator))))
   `(font-lock-preprocessor-face ((,class (:foreground ,builtin))))
   `(font-lock-regexp-grouping-backslash ((,class (:foreground ,operator))))
   `(font-lock-regexp-grouping-construct ((,class (:foreground ,operator))))

    ;; PHP specific
    `(php-function-call ((,class (:foreground ,func))))
    `(php-function-call-traditional ((,class (:foreground ,func))))

   ;; Mode line
   `(mode-line ((,class (:background ,line :foreground ,fg :box nil))))
   `(mode-line-inactive ((,class (:background ,inactive-bg :foreground ,comment :box nil))))
   `(mode-line-buffer-id ((,class (:weight bold))))
   `(mode-line-emphasis ((,class (:weight bold))))
   `(mode-line-highlight ((,class (:background ,visual))))

   ;; Search
   `(isearch ((,class (:background ,search :foreground ,fg :weight bold))))
   `(isearch-fail ((,class (:background ,error :foreground ,bg))))
   `(lazy-highlight ((,class (:background ,search :foreground ,fg))))

   ;; Line numbers
   `(line-number ((,class (:foreground ,comment :background ,bg))))
   `(line-number-current-line ((,class (:foreground ,fg :background ,line :weight bold))))

   ;; Parentheses
   `(show-paren-match ((,class (:background ,visual :weight bold))))
   `(show-paren-mismatch ((,class (:background ,error :foreground ,bg :weight bold))))

   ;; Completion
   `(completions-common-part ((,class (:foreground ,keyword))))
   `(completions-first-difference ((,class (:foreground ,func :weight bold))))

   ;; Dired
   `(dired-directory ((,class (:foreground ,keyword :weight bold))))
   `(dired-symlink ((,class (:foreground ,hint))))
   `(dired-flagged ((,class (:foreground ,error :weight bold))))
   `(dired-marked ((,class (:foreground ,plus :weight bold))))

   ;; Org mode
   `(org-level-1 ((,class (:foreground ,keyword :weight bold :height 1.3))))
   `(org-level-2 ((,class (:foreground ,func :weight bold :height 1.2))))
   `(org-level-3 ((,class (:foreground ,type :weight bold :height 1.1))))
   `(org-level-4 ((,class (:foreground ,builtin :weight bold))))
   `(org-level-5 ((,class (:foreground ,property :weight bold))))
   `(org-level-6 ((,class (:foreground ,parameter :weight bold))))
   `(org-level-7 ((,class (:foreground ,string :weight bold))))
   `(org-level-8 ((,class (:foreground ,number :weight bold))))
   `(org-document-title ((,class (:foreground ,keyword :weight bold :height 1.4))))
   `(org-code ((,class (:foreground ,builtin))))
   `(org-verbatim ((,class (:foreground ,string))))
   `(org-block ((,class (:background ,inactive-bg :extend t))))
   `(org-block-begin-line ((,class (:foreground ,comment :background ,line))))
   `(org-block-end-line ((,class (:foreground ,comment :background ,line))))
   `(org-link ((,class (:foreground ,keyword :underline t))))
   `(org-date ((,class (:foreground ,hint))))
   `(org-done ((,class (:foreground ,plus :weight bold))))
   `(org-todo ((,class (:foreground ,error :weight bold))))

   ;; Markdown
   `(markdown-header-face-1 ((,class (:foreground ,keyword :weight bold :height 1.3))))
   `(markdown-header-face-2 ((,class (:foreground ,func :weight bold :height 1.2))))
   `(markdown-header-face-3 ((,class (:foreground ,type :weight bold :height 1.1))))
   `(markdown-header-face-4 ((,class (:foreground ,builtin :weight bold))))
   `(markdown-code-face ((,class (:foreground ,builtin :background ,inactive-bg))))
   `(markdown-inline-code-face ((,class (:foreground ,builtin))))
   `(markdown-link-face ((,class (:foreground ,keyword :underline t))))
   `(markdown-url-face ((,class (:foreground ,hint :underline t))))

   ;; Diff
   `(diff-added ((,class (:foreground ,plus :background ,bg))))
   `(diff-removed ((,class (:foreground ,error :background ,bg))))
   `(diff-changed ((,class (:foreground ,delta :background ,bg))))
   `(diff-header ((,class (:foreground ,keyword :weight bold))))
   `(diff-file-header ((,class (:foreground ,func :weight bold))))
   `(diff-hunk-header ((,class (:foreground ,type :background ,line))))

   ;; Magit
   `(magit-section-heading ((,class (:foreground ,keyword :weight bold))))
   `(magit-branch-local ((,class (:foreground ,keyword))))
   `(magit-branch-remote ((,class (:foreground ,plus))))
   `(magit-diff-added ((,class (:foreground ,plus :background ,bg))))
   `(magit-diff-removed ((,class (:foreground ,error :background ,bg))))
   `(magit-diff-context ((,class (:foreground ,comment))))
   `(magit-diff-hunk-heading ((,class (:foreground ,type :background ,line))))
   `(magit-diff-hunk-heading-highlight ((,class (:foreground ,type :background ,visual))))

   ;; Company
   `(company-tooltip ((,class (:background ,inactive-bg :foreground ,fg))))
   `(company-tooltip-selection ((,class (:background ,visual))))
   `(company-tooltip-common ((,class (:foreground ,keyword :weight bold))))
   `(company-tooltip-annotation ((,class (:foreground ,comment))))
   `(company-scrollbar-bg ((,class (:background ,line))))
   `(company-scrollbar-fg ((,class (:background ,float-border))))

   ;; Corfu
   `(corfu-default ((,class (:background ,inactive-bg :foreground ,fg))))
   `(corfu-current ((,class (:background ,visual :foreground ,fg :weight bold))))
   `(corfu-bar ((,class (:background ,float-border))))
   `(corfu-border ((,class (:background ,float-border))))

   ;; Vertico
   `(vertico-current ((,class (:background ,visual :weight bold))))

   ;; Flycheck
   `(flycheck-error ((,class (:underline (:style wave :color ,error)))))
   `(flycheck-warning ((,class (:underline (:style wave :color ,warning)))))
   `(flycheck-info ((,class (:underline (:style wave :color ,hint)))))

   ;; Flymake
   `(flymake-error ((,class (:underline (:style wave :color ,error)))))
   `(flymake-warning ((,class (:underline (:style wave :color ,warning)))))
   `(flymake-note ((,class (:underline (:style wave :color ,hint)))))

   ;; Eglot
   `(eglot-diagnostic-tag-unnecessary-face ((,class (:foreground ,comment :strike-through t))))
   `(eglot-diagnostic-tag-deprecated-face ((,class (:foreground ,comment :strike-through t))))

   ;; Doom modeline
   `(doom-modeline-bar ((,class (:background ,keyword))))
   `(doom-modeline-buffer-modified ((,class (:foreground ,warning :weight bold))))
   `(doom-modeline-buffer-path ((,class (:foreground ,property))))
   `(doom-modeline-project-dir ((,class (:foreground ,keyword :weight bold))))

   ;; Treesit
   `(tree-sitter-hl-face:function ((,class (:foreground ,func))))
   `(tree-sitter-hl-face:function.call ((,class (:foreground ,func))))
   `(tree-sitter-hl-face:method ((,class (:foreground ,func))))
   `(tree-sitter-hl-face:method.call ((,class (:foreground ,func))))
   `(tree-sitter-hl-face:type ((,class (:foreground ,type))))
   `(tree-sitter-hl-face:type.builtin ((,class (:foreground ,builtin :weight bold))))
   `(tree-sitter-hl-face:property ((,class (:foreground ,property))))
   `(tree-sitter-hl-face:variable ((,class (:foreground ,property))))
   `(tree-sitter-hl-face:variable.parameter ((,class (:foreground ,parameter))))
   `(tree-sitter-hl-face:constant ((,class (:foreground ,constant :weight bold))))
   `(tree-sitter-hl-face:constant.builtin ((,class (:foreground ,constant :weight bold))))
   `(tree-sitter-hl-face:string ((,class (:foreground ,string :slant italic))))
   `(tree-sitter-hl-face:number ((,class (:foreground ,number))))
   `(tree-sitter-hl-face:operator ((,class (:foreground ,operator))))
   `(tree-sitter-hl-face:keyword ((,class (:foreground ,keyword))))

   ;; Evil
   `(evil-ex-lazy-highlight ((,class (:background ,search :foreground ,fg))))
   `(evil-ex-substitute-matches ((,class (:background ,error :foreground ,bg))))
   `(evil-ex-substitute-replacement ((,class (:background ,plus :foreground ,bg))))
   
    ;; Evil mode-line states
    `(doom-modeline-evil-normal-state ((,class (:foreground ,fg :weight bold))))
    `(doom-modeline-evil-insert-state ((,class (:foreground ,plus :weight bold))))
    `(doom-modeline-evil-visual-state ((,class (:foreground ,warning))))
    `(doom-modeline-evil-emacs-state ((,class (:foreground ,hint))))
    `(doom-modeline-evil-motion-state ((,class (:foreground ,type))))
    `(doom-modeline-evil-operator-state ((,class (:foreground ,parameter))))))

(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'vague)

;;; vague-theme.el ends here

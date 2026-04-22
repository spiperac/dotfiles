;;; vague-theme.el --- A cool, dark, low contrast theme -*- lexical-binding: t; -*-
;; Ported from vague.nvim (https://github.com/vague-theme/vague.nvim)

;;; Code:

(deftheme vague "A cool, dark, low contrast theme. Pastel yet vivid, like a fleeting memory.")

(let ((bg         "#141415")
      (inactive-bg "#1c1c24")
      (fg         "#cdcdcd")
      (comment    "#606079")
      (line       "#252530")
      (float-border "#878787")
      (builtin    "#b4d4cf")
      (func       "#c48282")
      (string     "#e8b589")
      (number     "#e0a363")
      (property   "#c3c3d5")
      (constant   "#aeaed1")
      (parameter  "#bb9dbd")
      (visual     "#333738")
      (error      "#d8647e")
      (warning    "#f3be7c")
      (hint       "#7e98e8")
      (operator   "#90a0b5")
      (keyword    "#6e94b2")
      (type       "#9bb4bc")
      (search     "#405065")
      (plus       "#7fa563")
      (delta      "#e8b589"))

  (custom-theme-set-faces
   'vague

   ;; Core
   `(default                  ((t (:background ,bg :foreground ,fg))))
   `(cursor                   ((t (:background ,fg))))
   `(fringe                   ((t (:background ,bg :foreground ,comment))))
   `(region                   ((t (:background ,visual))))
   `(highlight                ((t (:background ,line))))
   `(hl-line                  ((t (:background ,line))))
   `(secondary-selection      ((t (:background ,inactive-bg))))
   `(vertical-border          ((t (:foreground ,line))))
   `(window-divider           ((t (:foreground ,line))))
   `(minibuffer-prompt        ((t (:foreground ,keyword))))
   `(link                     ((t (:foreground ,hint :underline t))))
   `(link-visited             ((t (:foreground ,parameter :underline t))))

   ;; Line numbers
   `(line-number              ((t (:background ,bg :foreground ,comment))))
   `(line-number-current-line ((t (:background ,bg :foreground ,float-border))))

   ;; Search
   `(isearch                  ((t (:background ,search :foreground ,fg))))
   `(lazy-highlight           ((t (:background ,search :foreground ,fg))))
   `(match                    ((t (:background ,search))))

   ;; Syntax
   `(font-lock-builtin-face          ((t (:foreground ,builtin))))
   `(font-lock-comment-face          ((t (:foreground ,comment :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comment))))
   `(font-lock-constant-face         ((t (:foreground ,constant))))
   `(font-lock-doc-face              ((t (:foreground ,comment :slant italic))))
   `(font-lock-function-name-face    ((t (:foreground ,func))))
   `(font-lock-keyword-face          ((t (:foreground ,keyword))))
   `(font-lock-negation-char-face    ((t (:foreground ,operator))))
   `(font-lock-number-face           ((t (:foreground ,number))))
   `(font-lock-operator-face         ((t (:foreground ,operator))))
   `(font-lock-preprocessor-face     ((t (:foreground ,keyword))))
   `(font-lock-property-name-face    ((t (:foreground ,property))))
   `(font-lock-punctuation-face      ((t (:foreground ,operator))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,string))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,string))))
   `(font-lock-string-face           ((t (:foreground ,string))))
   `(font-lock-type-face             ((t (:foreground ,type))))
   `(font-lock-variable-name-face    ((t (:foreground ,parameter))))
   `(font-lock-warning-face          ((t (:foreground ,warning))))

   ;; Mode line
   `(mode-line                ((t (:background ,line :foreground ,fg))))
   `(mode-line-inactive       ((t (:background ,inactive-bg :foreground ,comment))))
   `(mode-line-buffer-id      ((t (:foreground ,func))))
   `(mode-line-emphasis       ((t (:foreground ,builtin))))
   `(mode-line-highlight      ((t (:foreground ,keyword))))

   ;; Completions / Popup
   `(completions-common-part  ((t (:foreground ,hint))))
   `(popup-face               ((t (:background ,inactive-bg :foreground ,fg))))
   `(popup-menu-selection-face ((t (:background ,visual))))

   ;; Corfu
   `(corfu-default            ((t (:background ,inactive-bg :foreground ,fg))))
   `(corfu-current            ((t (:background ,visual :foreground ,fg))))
   `(corfu-bar                ((t (:background ,line))))
   `(corfu-border             ((t (:background ,float-border))))
   `(corfu-annotations        ((t (:foreground ,comment))))
   `(corfu-deprecated         ((t (:foreground ,comment :strike-through t))))

   ;; Vertico
   `(vertico-current          ((t (:background ,visual))))

   ;; Orderless
   `(orderless-match-face-0   ((t (:foreground ,hint :bold t))))
   `(orderless-match-face-1   ((t (:foreground ,builtin :bold t))))
   `(orderless-match-face-2   ((t (:foreground ,string :bold t))))
   `(orderless-match-face-3   ((t (:foreground ,type :bold t))))

   ;; Eglot / LSP
   `(eglot-highlight-symbol-face ((t (:background ,line))))
   `(eglot-diagnostic-tag-unnecessary-face ((t (:foreground ,comment))))

   ;; Diagnostics
   `(flymake-error            ((t (:underline (:style wave :color ,error)))))
   `(flymake-warning          ((t (:underline (:style wave :color ,warning)))))
   `(flymake-note             ((t (:underline (:style wave :color ,hint)))))
   `(flycheck-error           ((t (:underline (:style wave :color ,error)))))
   `(flycheck-warning         ((t (:underline (:style wave :color ,warning)))))
   `(flycheck-info            ((t (:underline (:style wave :color ,hint)))))

   ;; Diff
   `(diff-added               ((t (:foreground ,plus))))
   `(diff-removed             ((t (:foreground ,error))))
   `(diff-changed             ((t (:foreground ,delta))))
   `(diff-header              ((t (:foreground ,comment))))
   `(diff-file-header         ((t (:foreground ,fg :bold t))))

   ;; Magit
   `(magit-section-heading    ((t (:foreground ,keyword :bold t))))
   `(magit-section-highlight  ((t (:background ,line))))
   `(magit-diff-added         ((t (:background "#1a2b1a" :foreground ,plus))))
   `(magit-diff-removed       ((t (:background "#2b1a1a" :foreground ,error))))
   `(magit-diff-added-highlight ((t (:background "#1e331e" :foreground ,plus))))
   `(magit-diff-removed-highlight ((t (:background "#331e1e" :foreground ,error))))
   `(magit-hash               ((t (:foreground ,comment))))
   `(magit-branch-local       ((t (:foreground ,builtin))))
   `(magit-branch-remote      ((t (:foreground ,type))))
   `(magit-tag                ((t (:foreground ,string))))

   ;; Treemacs
   `(treemacs-root-face       ((t (:foreground ,func :bold t))))
   `(treemacs-directory-face  ((t (:foreground ,keyword))))
   `(treemacs-file-face       ((t (:foreground ,fg))))
   `(treemacs-git-modified-face ((t (:foreground ,warning))))
   `(treemacs-git-added-face  ((t (:foreground ,plus))))
   `(treemacs-git-untracked-face ((t (:foreground ,comment))))

   ;; Org
   `(org-block                ((t (:background ,inactive-bg))))
   `(org-block-begin-line     ((t (:foreground ,comment :background ,inactive-bg))))
   `(org-block-end-line       ((t (:foreground ,comment :background ,inactive-bg))))
   `(org-code                 ((t (:foreground ,string))))
   `(org-date                 ((t (:foreground ,hint))))
   `(org-document-info        ((t (:foreground ,comment))))
   `(org-document-title       ((t (:foreground ,fg :bold t))))
   `(org-done                 ((t (:foreground ,plus))))
   `(org-headline-done        ((t (:foreground ,comment))))
   `(org-hide                 ((t (:foreground ,bg))))
   `(org-level-1              ((t (:foreground ,func :bold t))))
   `(org-level-2              ((t (:foreground ,keyword))))
   `(org-level-3              ((t (:foreground ,type))))
   `(org-level-4              ((t (:foreground ,builtin))))
   `(org-level-5              ((t (:foreground ,parameter))))
   `(org-level-6              ((t (:foreground ,string))))
   `(org-link                 ((t (:foreground ,hint :underline t))))
   `(org-todo                 ((t (:foreground ,error))))
   `(org-verbatim             ((t (:foreground ,string))))

   ;; Whitespace
   `(whitespace-space         ((t (:foreground ,line))))
   `(whitespace-tab           ((t (:foreground ,line))))
   `(whitespace-newline       ((t (:foreground ,line))))

   ;; Error / Warning faces
   `(error                    ((t (:foreground ,error))))
   `(warning                  ((t (:foreground ,warning))))
   `(success                  ((t (:foreground ,plus))))

   ;; Paren matching
   `(show-paren-match         ((t (:background ,search :foreground ,fg :bold t))))
   `(show-paren-mismatch      ((t (:background ,error :foreground ,fg))))

   ;; Rainbow delimiters
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,func))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,builtin))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,type))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,keyword))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,parameter))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,string))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,hint))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground ,error))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'vague)
;;; vague-theme.el ends here

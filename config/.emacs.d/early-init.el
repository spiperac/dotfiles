;;; early-init.el --- Loaded before init -*- lexical-binding: t; -*-

;;; Commentary:
;; This file contains the early-init configuration.
;; Organized for clarity and modularity.

;;; Code:

(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")  ; char-displayable-p returns 'unicode
(set-language-environment "English")  ; char-displayable-p returns nil

(provide 'early-init)
;;; early-init.el ends here

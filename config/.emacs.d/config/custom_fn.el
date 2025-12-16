
;;; custom_fn.el --- User Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This file contains custom functions which can be called with scripts outside of emacs. 

(defun create-note (filename)
  "Create and open a new note in ~/Vault/notes/"
  (interactive "sNote name: ")
  (let* ((notes-dir (expand-file-name "~/Vault/notes/"))
         (full-path (concat notes-dir 
                           (if (string-match-p "\\." filename)
                               filename
                             (concat filename ".md")))))
    (find-file full-path)))

(provide 'custom_fn)

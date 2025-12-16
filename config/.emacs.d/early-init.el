
;; Emacs Server
(load "server")
(unless (server-running-p) (server-start))
(add-to-list 'default-frame-alist '(undecorated . t))


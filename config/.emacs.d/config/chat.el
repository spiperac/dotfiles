(setq erc-server "irc.libera.chat")   ;; IRC server (example: Freenode)
(setq erc-nick "cqmort")       ;; Your IRC nickname
(setq erc-port 6667)                  ;; Default IRC port
(setq erc-autojoin-channels-alist '(("irc.libera.chat" "#lugons" "#balccon"))) 

(setq erc-autojoin-timing 'ident
      erc-auto-join-mode t
      erc-fill-function 'erc-fill-static
      erc-fill-static-center 22
      erc-hide-list '("JOIN" "PART" "QUIT")
      erc-lurker-hide-list '("JOIN" "PART" "QUIT")
      erc-lurker-threshold-time 43200
      erc-prompt-for-nickserv-password nil
      erc-server-reconnect-attempts 5
      erc-server-reconnect-timeout 3
      erc-kill-buffer-on-part t
      erc-track-exclude-types '("JOIN" "MODE" "NICK" "PART" "QUIT"
                               "324" "329" "332" "333" "353" "477"))

;; Enable ERC modules correctly
(setq erc-modules '(notifications spelling))

;; Enable automatic connection on startup
(add-hook 'erc-mode-hook (lambda ()
                           (erc-update-mode-line)
                           (erc-timestamp-mode)))

;; Follow channels and dont follow private messages ( open in background).
(setq erc-join-buffer 'current)
(setq erc-auto-query 'bury)

(use-package erc-hl-nicks
  :after erc)

(use-package erc-image
  :after erc)


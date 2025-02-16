;;; media.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;;  This file contains anything related to media.  Music, videos, etc...

;;; Code:

(use-package emms
  :defer t
  :config
    (require 'emms-setup)
    (require 'emms-player-mpd)
    (emms-all)
    (setq emms-player-list '(emms-player-mpd))
    (add-to-list 'emms-info-functions 'emms-info-mpd)
    (add-to-list 'emms-player-list 'emms-player-mpd)

    ;; Socket is not supported
    (setq emms-player-mpd-server-name "localhost")
    (setq emms-player-mpd-server-port "6600")
    (setq emms-player-mpd-music-directory "~/Music")
    (emms-player-mpd-connect)

    (add-hook 'emms-playlist-cleared-hook 'emms-player-mpd-clear)
    )

(provide 'media)
;;; media.el ends here

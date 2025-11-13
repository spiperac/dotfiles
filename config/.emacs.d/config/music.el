;;; music.el --- User Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This file contains music player for my subsonic server.
;;; Code:

(use-package subsonic
  :commands subsonic
  :bind (("C-c m" . subsonic))
  :custom
  (subsonic-host "192.168.200.113:4533")
  (subsonic-ssl nil)
  (subsonic-enable-art t))

(with-eval-after-load 'subsonic
  (define-key subsonic-artist-mode-map (kbd "RET") #'subsonic-open-album)
  (define-key subsonic-album-mode-map (kbd "RET") #'subsonic-open-tracks)
  (define-key subsonic-album-type-mode-map (kbd "RET") #'subsonic-open-tracks)
  (define-key subsonic-tracks-mode-map (kbd "RET") #'subsonic-play-tracks)
  (define-key subsonic-search-mode-map (kbd "RET") #'subsonic-open-search-result))

(with-eval-after-load 'subsonic
  (evil-define-key 'normal subsonic-artist-mode-map (kbd "RET") #'subsonic-open-album)
  (evil-define-key 'normal subsonic-album-mode-map (kbd "RET") #'subsonic-open-tracks)
  (evil-define-key 'normal subsonic-album-type-mode-map (kbd "RET") #'subsonic-open-tracks)
  (evil-define-key 'normal subsonic-tracks-mode-map (kbd "RET") #'subsonic-play-tracks)
  (evil-define-key 'normal subsonic-search-mode-map (kbd "RET") #'subsonic-open-search-result))

(evil-define-key 'normal 'global (kbd "SPC m m") #'subsonic)
(evil-define-key 'normal 'global (kbd "SPC m s") #'subsonic-search)
(evil-define-key 'normal 'global (kbd "SPC m p") #'subsonic-toggle-playing)

(provide 'music)
;;; music.el ends here

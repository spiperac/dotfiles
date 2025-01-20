;;; news.el --- RSS Feed Configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; Personal configuration for RSS feeds using Elfeed.
;;; Code:

(use-package elfeed
  :ensure t
  :bind ("C-x w" . elfeed) ;; Recommended keybinding
  )

(evil-define-key 'normal elfeed-search-mode-map
  (kbd "RET") 'elfeed-search-show-entry
  (kbd "o") 'elfeed-search-show-entry
  (kbd "s") 'elfeed-search-live-filter
  (kbd "q") 'elfeed-search-quit-window
  (kbd "c") 'elfeed-search-clear-filter
  (kbd "U") 'elfeed-update)

(evil-define-key 'normal elfeed-show-mode-map
  (kbd "q") 'elfeed-kill-buffer)

;; Feeds list
(setq elfeed-feeds
      '(
        "https://www.youtube.com/feeds/videos.xml?channel_id=UCAiiOTio8Yu69c3XnR7nQBQ"; SystemCrafters
        "https://hackaday.com/blog/feed/"))       ; Hackaday


;; Youtube
;; Better YouTube entry formatting
(defun my-elfeed-youtube-content (entry)
  (let* ((title (elfeed-entry-title entry))
         (link (elfeed-entry-link entry))
         (author (elfeed-meta entry :author)))
    (concat
     (format "Title: %s\n" title)
     (format "Author: %s\n" author)
     (format "Link: %s\n\n" link)
     "Watch in MPV: Press 'v'")))

(setq elfeed-show-entry-format 'my-elfeed-youtube-content)

(defun my-elfeed-play-with-mpv ()
  "Play entry link with mpv."
  (interactive)
  (let* ((entry (if (eq major-mode 'elfeed-show-mode)
                    elfeed-show-entry
                  (elfeed-search-selected :single)))
         (link (elfeed-entry-link entry)))
    (when link
      (start-process "mpv" nil "mpv" link))))

;; Bind 'v' to play video in both search and show modes
(evil-define-key 'normal elfeed-show-mode-map
  (kbd "v") 'my-elfeed-play-with-mpv)

(evil-define-key 'normal elfeed-search-mode-map
  (kbd "v") 'my-elfeed-play-with-mpv)


(provide 'news)
;;; news.el ends here

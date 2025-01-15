(defun start-pomodoro-cycle ()
  "Start a short Pomodoro cycle with a 5-second work session and a 5-second break."
  (interactive)
  (org-timer-set-timer "45:00")  ;; Start the 5-second work session timer
  (run-at-time "46 min" nil
               (lambda ()
                 (org-timer-set-timer "15:00")  ;; Start the 5-second break timer
                 )))  ;; Update the mode-line to show the break timer



(global-set-key (kbd "C-x p") 'start-pomodoro-cycle)
(global-set-key (kbd "C-x P") 'org-timer-pause-or-continue)


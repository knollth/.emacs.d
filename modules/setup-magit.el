;;; setup-magit.el --- Magit -*- lexical-binding: t -*-

(straight-use-package 'magit)

(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)

(keymap-global-set "C-x g" #'magit-status)
(keymap-global-set "C-x M-g" #'magit-dispatch)

;; Motion state for magit buffers is configured in `meow-mode-state-list'
;; (see setup-meow.el), which keeps meow and magit independent of load order.

(provide 'setup-magit)
;;; setup-magit.el ends here

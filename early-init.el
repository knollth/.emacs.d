;;; early-init.el --- UI and performance tweaks -*- lexical-binding: t -*-

(setopt inhibit-startup-screen t)
(setopt ring-bell-function 'ignore)

(menu-bar-mode 1)
(tool-bar-mode -1)   ; disable toolbar mode
(scroll-bar-mode -1) ; disable vertical scrollbar

(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(horizontal-scroll-bars . nil))
(add-to-list 'default-frame-alist '(undecorated . t))

(setopt gc-cons-threshold (* 150 1024 1024))
(add-function :after after-focus-change-function
  (lambda ()
    (unless (cl-some #'frame-focus-state (frame-list))
      (garbage-collect))))

(setopt pixel-scroll-precision-mode t)
(setopt scroll-conservatively 101)
(setopt scroll-margin 3)
(setopt display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)
(add-hook 'dired-mode-hook #'display-line-numbers-mode)

(provide 'early-init)

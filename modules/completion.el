;;; completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t -*-

(straight-use-package 'vertico)
(vertico-mode)

(straight-use-package 'consult)
(keymap-global-set "C-s" #'consult-line)
(keymap-global-set "C-x b" #'consult-buffer)
(keymap-global-set "M-y" #'consult-yank-pop)

(straight-use-package 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles basic partial-completion))))

(straight-use-package 'marginalia)
(marginalia-mode)

(straight-use-package 'corfu)
(setq corfu-cycle t)
(global-corfu-mode)

(add-hook 'prog-mode-hook #'electric-pair-mode)

(provide 'completion)

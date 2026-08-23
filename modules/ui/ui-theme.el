;;; ui/theme.el --- Theme configuration -*- lexical-binding: t -*-

(straight-use-package 'modus-themes)
(straight-use-package 'ef-themes)

(with-eval-after-load 'modus-themes
  (modus-themes-include-derivatives-mode 1))

(with-eval-after-load 'ef-themes
  (setopt ef-themes-variable-pitch-ui t)
  (setopt ef-themes-mixed-fonts t))

(add-hook 'after-init-hook
          (lambda ()
            (load-theme 'ef-spring t)))

(provide 'ui-theme)

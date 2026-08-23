;;; ui/fonts.el --- Font configuration -*- lexical-binding: t -*-

(defun my/font-available-p (font)
  "Return non-nil if FONT is available."
  (find-font (font-spec :name font)))

(defun my/set-fonts ()
  "Set default and variable-pitch fonts."
  (let ((mono (or (seq-find #'my/font-available-p
                            '("JetBrainsMono Nerd Font"
                              "Hack Nerd Font"
                              "FiraCode Nerd Font"
                              "Iosevka Nerd Font"
                              "DejaVu Sans Mono"))
                  "monospace"))
        (var (or (seq-find #'my/font-available-p
                           '("Iosevka Aile"
                             "DejaVu Sans"
                             "sans-serif"))
                 "sans-serif")))
    (set-face-attribute 'default nil
                        :family mono
                        :height 130
                        :weight 'regular)
    (set-face-attribute 'fixed-pitch nil
                        :family mono
                        :height 130)
    (set-face-attribute 'variable-pitch nil
                        :family var
                        :height 130)))

(add-hook 'after-init-hook #'my/set-fonts)

(provide 'ui-fonts)

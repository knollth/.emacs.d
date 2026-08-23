;;; ui/modeline.el --- Custom modeline -*- lexical-binding: t -*-

(defface ml/default  '((t :inherit default)) "Normal segment.")
(defface ml/accent   '((t :inherit default)) "Active/state segment.")
(defface ml/dim      '((t :inherit default)) "Background info.")
(defface ml/modified '((t :inherit default)) "Unsaved buffer.")
(defface ml/vc       '((t :inherit default)) "Version control.")

(defun ml/box (color)
  "Tab-shaped box spec for COLOR."
  `(:line-width (3 . 1) :color ,color))

(defun ml/setup-faces (&rest _)
  "Paint modeline faces from the active theme's palette."
  (modus-themes-with-colors
    (set-face-attribute 'ml/default  nil :background bg-dim          :foreground fg-main :box (ml/box bg-dim))
    (set-face-attribute 'ml/accent   nil :background bg-active       :foreground fg-main :box (ml/box bg-active))
    (set-face-attribute 'ml/dim      nil :background bg-main         :foreground fg-dim  :box (ml/box bg-main))
    (set-face-attribute 'ml/modified nil :background bg-main         :foreground red     :box (ml/box bg-main))
    (set-face-attribute 'ml/vc       nil :background bg-cyan-subtle  :foreground cyan   :box (ml/box bg-cyan-subtle))))

(defun ml/seg (text &optional face)
  "Wrap TEXT with FACE (default ml/default)."
  (propertize (format " %s " text) 'face (or face 'ml/default)))

(defun ml/meow ()
  (when (bound-and-true-p meow-mode)
    (ml/seg (string-trim (meow-indicator)) 'ml/accent)))

(defun ml/buffer ()
  (let ((mod (cond (buffer-read-only "◊ ")
                   ((buffer-modified-p)
                    (propertize "● " 'face 'ml/modified))
                   (t ""))))
    (ml/seg (concat mod (buffer-name)))))

(defun ml/major-mode ()
  (ml/seg (format-mode-line mode-name)
          (if (bound-and-true-p eglot--managed-mode) 'ml/vc 'ml/dim)))

(defun ml/vc ()
  (when-let* ((file buffer-file-name)
              (backend (vc-backend file))
              (branch (substring-no-properties vc-mode 5)))
    (ml/seg (concat " " branch) 'ml/vc)))

(defun ml/position () (ml/seg "%l:%c" 'ml/dim))

(setq display-time-default-load-average nil
      display-time-format "%H:%M"
      battery-mode-line-format "%p")
(display-time-mode 1)
(display-battery-mode 1)

(defun ml/battery () (ml/seg (concat battery-mode-line-string "%%") 'ml/dim))
(defun ml/time ()    (ml/seg display-time-string 'ml/dim))

(setq-default mode-line-format
              '((:eval (ml/meow))
                (:eval (ml/buffer))
                (:eval (ml/vc))
                (:eval (ml/major-mode))
                mode-line-format-right-align
                (:eval (ml/position))
                (:eval (ml/battery))
                (:eval (ml/time))))

(add-hook 'modus-themes-after-load-theme-hook #'ml/setup-faces)
(add-hook 'enable-theme-functions #'ml/setup-faces)
(with-eval-after-load 'ef-themes
  (ml/setup-faces))

(provide 'ui-modeline)

;;; ui/init.el --- UI configuration entry point -*- lexical-binding: t -*-

(add-to-list 'load-path (file-name-directory (or load-file-name buffer-file-name)))

(require 'ui-theme)
(require 'ui-fonts)
(require 'ui-modeline)

(provide 'ui-init)

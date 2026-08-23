;;; init.el --- Emacs configuration entry point -*- lexical-binding: t -*-

(setopt custom-file (expand-file-name "~/.emacs.custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setopt backup-directory-alist '(("." . "~/.emacs.d/backups")))

(repeat-mode 1)

;; Straight bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-directory)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Modules
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(require 'setup-meow)
(require 'completion)
(require 'setup-magit)
(require 'setup-org)
(require 'languages)

;; UI
(add-to-list 'load-path (expand-file-name "modules/ui" user-emacs-directory))
(require 'ui-init)

(provide 'init)

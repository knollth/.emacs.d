;;; setup-org.el --- Org mode, LaTeX previews, CDLaTeX -*- lexical-binding: t -*-

(straight-use-package
 `(org
   :fork (:host nil
          :repo "https://git.tecosaur.net/tec/org-mode.git"
          :branch "dev"
          :remote "tecosaur")
   :files (:defaults "etc")
   :build t
   :pre-build
   (with-temp-file "org-version.el"
     (require 'lisp-mnt)
     (let ((version
            (with-temp-buffer
              (insert-file-contents "lisp/org.el")
              (lm-header "version")))
           (git-version
            (string-trim
             (with-temp-buffer
               (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
               (buffer-string)))))
       (insert
        (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
        (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
        "(provide 'org-version)\n")))
   :pin nil))

(keymap-global-set "C-c a" #'org-agenda)
(keymap-global-set "C-c c" #'org-capture)
(keymap-global-set "C-c l" #'org-latex-preview)

(add-hook 'org-mode-hook #'org-latex-preview-mode)

(setq org-edit-src-content-indentation 1
      org-export-babel-evaluate nil
      org-directory "~/org"
      org-agenda-files '("~/org/agenda")
      org-agenda-include-diary t
      org-image-actual-width nil

      ;; Async latex preview (tecosaur)
      org-latex-preview-mode-display-live t
      org-latex-preview-mode-update-delay 0.3
      org-latex-preview-process-precompile t
      org-latex-preview-numbered t
      org-latex-preview-appearance-options
      '(:foreground default
        :background default
        :zoom 1.4
        :html-scale 1.0))

(with-eval-after-load 'org
  (require 'ox-beamer)
  (require 'ox-md)
  (setq org-capture-templates
        '(("i" "Inbox" entry (file "~/org/agenda/inbox.org")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:")
          ("a" "Appointment" entry (file "~/org/agenda/inbox.org")
           "* %?\n%^T"
           :prepend t))))

(provide 'setup-org)
;;; setup-org.el ends here

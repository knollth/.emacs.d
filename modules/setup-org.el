;;; setup-org.el --- Org mode, LaTeX previews, CDLaTeX -*- lexical-binding: t -*-

;; ================ Org (tecosaur fork) ================

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

;; ================ Keybindings ================

(keymap-global-set "C-c a" #'org-agenda)
(keymap-global-set "C-c c" #'org-capture)
(keymap-global-set "C-c l" #'org-latex-preview)

;; ================ Org configuration ================

(with-eval-after-load 'org
  (require 'ox-md)

  (setopt org-directory "~/org"
          org-agenda-files '("~/org/agenda")
          org-agenda-include-diary t
          org-edit-src-content-indentation 1
          org-export-babel-evaluate nil
          org-image-actual-width nil)
  
  (setopt org-latex-preview-mode-display-live t
	  org-latex-preview-mode-update-delay 0.3
	  org-latex-preview-process-precompile t
	  org-latex-preview-numbered t
	  org-latex-preview-appearance-options
	  '(:foreground default
			:background default
			:zoom 1.4
			:html-scale 1.0))
  ;; Enable live LaTeX preview in Org buffers
  (add-hook 'org-mode-hook #'org-latex-preview-mode)

  (setopt org-capture-templates
          '(("i" "Inbox" entry (file "~/org/agenda/inbox.org")
             "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:")
            ("a" "Appointment" entry (file "~/org/agenda/inbox.org")
             "* %?\n%^T"
             :prepend t))))


;; ================ Organizing Notes ================

(straight-use-package 'org-roam)
(straight-use-package 'denote)
(straight-use-package
 '(denote-roam :type git :host github :repo "knollth/denote-roam"))


(with-eval-after-load 'org-roam
  (setopt org-roam-directory (expand-file-name "~/notes/"))
  (make-directory org-roam-directory t)
  (org-roam-db-autosync-mode))

(with-eval-after-load 'denote
  (setopt denote-directory (expand-file-name "~/notes/")
          denote-known-keywords '("emacs" "work" "idea" "math")
          denote-infer-keywords t
          denote-sort-keywords t
          denote-prompts '(title keywords)))


(provide 'setup-org)
;;; setup-org.el ends here

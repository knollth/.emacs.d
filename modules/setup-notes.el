;;; setup-notes.el --- Org notes: denote + org-roam via denote-roam -*- lexical-binding: t -*-

;; Layout:
;;   ~/org/notes/         denote + org-roam (all knowledge: math, eng, uni, ...)
;;     ~/org/notes/journal/     dailies: dump zone, triaged in the evening;
;;                              no :ID: -> never roam nodes (see denote-roam)
;;     ~/org/notes/assets/      babel outputs, pasted/snipped images
;;     ~/org/notes/attachments/ org-attach (C-c C-a): id-hashed per-note files
;;   ~/org/finances/      plain org files, scanned by nothing
;; Todos/deadlines live in Radicale (CalDAV), not in org.

;; Nothing loads at startup: packages are installed, options are set,
;; keys are bound to autoloaded commands.  The whole stack (org,
;; denote, org-roam, denote-roam) loads on first use.

;; ================ Install (no loading) ================

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

(straight-use-package 'denote)
(straight-use-package 'denote-journal)
(straight-use-package 'org-roam)
(straight-use-package
 '(denote-roam :type git :host github :repo "knollth/denote-roam"))

;; ================ Dirs (recreate on fresh machines) ================

(dolist (dir '("~/org/notes" "~/org/notes/journal" "~/org/notes/attachments"))
  (unless (file-directory-p dir)
    (make-directory dir t)))

;; ================ Options (set BEFORE anything loads) ================

(setopt org-directory "~/org"
        org-edit-src-content-indentation 1
        org-export-babel-evaluate nil
        org-image-actual-width nil
        ;; denote
        denote-directory "~/org/notes/"
        denote-known-keywords '("emacs" "work" "idea" "math" "uni")
        denote-infer-keywords t
        denote-sort-keywords t
        denote-prompts '(title keywords)
        ;; dailies (denote-journal): subdir of denote-directory; denote-roam
        ;; skips :ID: insertion there, so dailies never enter the roam graph
        denote-journal-directory "~/org/notes/journal/"
        ;; denote-roam / org-roam (db path pinned: org-roam derives it
        ;; from `org-roam-directory' at load time, so set it explicitly)
        denote-roam-directory "~/org/notes/"
        org-roam-db-location "~/org/notes/org-roam.db")

;; ================ First-use activation ================

;; Runs once, when the first denote-roam command loads the stack:
;; the mode forces org file-type, syncs denote/org-roam directories to
;; `denote-roam-directory' and installs the :ID:-insertion hook; then
;; the roam db starts and ~/org/notes gets indexed.
(with-eval-after-load 'denote-roam
  (denote-roam-mode 1)
  (org-roam-db-autosync-mode 1)
  (org-roam-db-sync))

;; ================ Helpers ================

(defun my/org-snip ()
  "Snip a screen region with slurp+grim and insert it as an image link.
When the tools are missing or fail (e.g. GNOME's compositor lacks
wlr-screencopy), fall back gracefully: use your desktop snip tool and
paste with \\[yank-media] (C-c n p) instead."
  (interactive)
  (unless (derived-mode-p 'org-mode)
    (user-error "Not in an org buffer"))
  (let ((path (expand-file-name
               (format-time-string "clipboard-%Y%m%dT%H%M%S.png")
               "~/org/notes/assets/")))
    (if (and (executable-find "grim") (executable-find "slurp")
             (= 0 (call-process "sh" nil nil nil "-c"
                    (format "grim -g \"$(slurp)\" %s"
                            (shell-quote-argument path)))))
        (progn (insert (org-link-make-string (concat "file:" path)))
               (org-display-inline-images))
      (message "snip unavailable here - use your desktop snip tool, then C-c n p"))))

(with-eval-after-load 'org
  (require 'ox-md)

  ;; babel artifacts & pasted images -> notes/assets/ (non-org files:
  ;; invisible to the roam graph and to C-c n u)
  (setopt org-babel-load-languages '((emacs-lisp . t) (shell . t) (dot . t))
          org-confirm-babel-evaluate nil
          ;; per-note curated files (C-c C-a): id-hashed dirs in notes/
          org-attach-id-dir "~/org/notes/attachments/"
          ;; pasted/dropped images (C-c n p) land in assets/, absolute links
          org-yank-image-save-method "~/org/notes/assets/")

  ;; paste an image from the clipboard into the current note
  (keymap-set org-mode-map "C-c n p" #'yank-media)

  ;; live LaTeX preview in org buffers (math/engineering notes)
  (setopt org-latex-preview-mode-display-live t
          org-latex-preview-mode-update-delay 0.3
          org-latex-preview-process-precompile t
          org-latex-preview-numbered t
          org-latex-preview-appearance-options
          '(:foreground default
                        :background default
                        :zoom 1.4
                        :html-scale 1.0))
  (add-hook 'org-mode-hook #'org-latex-preview-mode))

;; ================ Keybindings (autoloaded, load on first press) ================

(keymap-global-set "C-c l" #'org-latex-preview)
(keymap-global-set "C-c n j" #'denote-journal-new-or-existing-entry)
(keymap-global-set "C-c n i" #'denote-roam-insert-or-create-node)
(keymap-global-set "C-c n o" #'denote-roam-find-or-create-node)
(keymap-global-set "C-c n u" #'denote-roam-dired-unlinked)

(provide 'setup-notes)
;;; setup-notes.el ends here

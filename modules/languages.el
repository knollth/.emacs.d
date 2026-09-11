;;; languages.el --- Language modes, eglot servers, formatting -*- lexical-binding: t -*-

(require 'treesit)

(defun my/eglot-add-server (mode cmd)
  "Add MODE -> CMD mapping to eglot-server-programs after eglot loads."
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs (cons mode cmd))))

(with-eval-after-load 'eglot
  (keymap-set eglot-mode-map "C-c h" #'eglot-inlay-hints-mode))
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1))) ; default off

;; apheleia does auto-format
(straight-use-package 'apheleia)
(add-hook 'tuareg-mode-hook #'apheleia-mode)
(add-hook 'python-ts-mode-hook #'apheleia-mode)

;; ------------------ Configuration Languages --------------

(straight-use-package 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(my/eglot-add-server 'nix-mode '("nixd"))
(add-hook 'nix-mode-hook #'apheleia-mode)

(straight-use-package 'kdl-mode)

;; ----- yaml -----
(straight-use-package 'yaml-pro)
(straight-use-package 'yaml-mode)

(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))
(add-hook 'yaml-ts-mode-hook
	  (lambda ()
	    (yaml-pro-ts-mode)
	    (require 'yaml-mode)
	    (setq-local indent-line-function #'yaml-indent-line)))

	    

(add-to-list 'treesit-language-source-alist
             '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml"))

(with-eval-after-load 'yaml-ts-mode
  (setopt yaml-ts-mode-indent-offset 2))

(my/eglot-add-server 'yaml-ts-mode '("yaml-language-server" "--stdio"))
;; ----- yaml (end) -----

(straight-use-package 'just-ts-mode)
(add-to-list 'treesit-language-source-alist
             '(just "https://github.com/casey/tree-sitter-just"))



(straight-use-package 'dockerfile-mode)

;; -------------------- Haskell -----------------------

(straight-use-package 'haskell-mode)
(add-to-list 'auto-mode-alist '("\\.hs\\'" . haskell-mode))
(my/eglot-add-server '(haskell-mode haskell-literate-mode)
                     '("haskell-language-server-wrapper" "--lsp"))
(add-hook 'haskell-mode-hook #'interactive-haskell-mode)
(with-eval-after-load 'haskell-mode
  (setq haskell-process-type 'cabal-repl))

;; -------------------- Rust -----------------------

;; rust-ts-mode is built-in
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(setq rust-ts-mode-indent-offset 4)

(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))

;; -------------------- TLA+ -----------------------

(straight-use-package
 '(tla+-mode :type git
             :host github
             :repo "ravenjoad/tlaplus-mode"
             :files ("lisp/*.el")))

(add-to-list 'auto-mode-alist '("\\.tla\\'" . tla+-mode))
(add-to-list 'treesit-language-source-alist
             '(tlaplus
               "https://github.com/tlaplus-community/tree-sitter-tlaplus"))

;; -------------------- Janet -----------------------

(straight-use-package
 '(janet-ts-mode :host github :repo "sogaiu/janet-ts-mode"))
(add-to-list 'auto-mode-alist '("\\.janet\\'" . janet-ts-mode))
(add-to-list 'treesit-language-source-alist
             '(janet-simple "https://github.com/sogaiu/tree-sitter-janet-simple"))

;; --------------------- Zig ------------------------

(straight-use-package
 '(zig-ts-mode :host nil :repo "https://codeberg.org/meow_king/zig-ts-mode"))
(add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-ts-mode))
(add-to-list 'auto-mode-alist '("\\.zon\\'" . zig-ts-mode))
(add-to-list 'treesit-language-source-alist
             '(zig "https://github.com/tree-sitter-grammars/tree-sitter-zig"))
(my/eglot-add-server 'zig-ts-mode '("zls"))

;; -------------------- C/C++ -----------------------

;; c-ts-mode is built-in
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'treesit-language-source-alist '(c "https://github.com/tree-sitter/tree-sitter-c"))
(add-to-list 'treesit-language-source-alist '(cpp "https://github.com/tree-sitter/tree-sitter-cpp"))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-ts-mode))
(setq c-ts-mode-indent-offset 8
      c-ts-mode-indent-style 'linux)

;; -------------------- Markdown -----------------------
(straight-use-package 'markdown-mode)

(add-to-list 'auto-mode-alist '("\\.\\(?:md\\|markdown\\)\\'" . gfm-mode))
(with-eval-after-load 'markdown-mode
  ;; Font-lock code blocks using their language's own mode (huge readability win)
  (setopt markdown-fontify-code-blocks-natively t)
   (setopt markdown-enable-math t))


;; -------------------- Typst -----------------------

(straight-use-package
 '(typst-ts-mode :host nil :repo "https://codeberg.org/meow_king/typst-ts-mode.git"))
(my/eglot-add-server 'typst-ts-mode '("tinymist" "lsp"))
(add-to-list 'treesit-language-source-alist
             '(typst "https://github.com/uben0/tree-sitter-typst"))
(add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode))
(with-eval-after-load 'typst-ts-mode
  (setq typst-ts-mode-indent-offset 2))

;; -------------------- OCaml -----------------------

(straight-use-package 'tuareg)
(add-hook 'tuareg-mode-hook #'prettify-symbols-mode)
(with-eval-after-load 'tuareg
  (setq tuareg-default-indent 2))

(straight-use-package 'utop)
(add-hook 'tuareg-mode-hook #'utop-minor-mode)
(with-eval-after-load 'utop
  (setq utop-command "utop -emacs"))

;; -------------------- Python -----------------------

;; python is built-in
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'treesit-language-source-alist '(python "https://github.com/tree-sitter/tree-sitter-python"))
(my/eglot-add-server '(python-mode python-ts-mode)
                     '("basedpyright-langserver" "--stdio"))
(setq python-indent-offset 4)

(provide 'languages)

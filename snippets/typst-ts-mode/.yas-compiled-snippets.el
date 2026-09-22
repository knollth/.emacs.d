;;; "Compiled" snippets and support files for `typst-ts-mode'  -*- lexical-binding:t -*-
;;; Snippet definitions:
;;;
(yas-define-snippets 'typst-ts-mode
		     '(("sum" "sum_(${1:i=1})^(${2:n}) $0" "sum"
			(my/typst-math-p) nil nil
			"/home/tom/.emacs.d/snippets/typst-ts-mode/sum"
			nil nil)
		       ("pd" "(diff ${1:f})/(diff ${2:x})$0" "partial"
			(my/typst-math-p) nil nil
			"/home/tom/.emacs.d/snippets/typst-ts-mode/partial"
			nil nil)
		       ("lim" "lim_(${1:n} -> ${2:oo}) $0\n" "limit"
			(my/typst-math-p) nil nil
			"/home/tom/.emacs.d/snippets/typst-ts-mode/limit"
			nil nil)
		       ("int"
			"integral_(${1:a})^(${2:b}) $0 dif ${3:x}"
			"integral" (my/typst-math-p) nil nil
			"/home/tom/.emacs.d/snippets/typst-ts-mode/integral"
			nil nil)
		       ("frac" "($1)/($2)$0" "fraction"
			(my/typst-math-p) nil nil
			"/home/tom/.emacs.d/snippets/typst-ts-mode/frac"
			nil nil)
		       ("cases"
			"cases(\n  $1 &\"if\" $2,\n  $3 &\"sonst\"\n)$0"
			"cases" (my/typst-math-p) nil nil
			"/home/tom/.emacs.d/snippets/typst-ts-mode/cases"
			nil nil)))


;;; Do not edit! File generated at Thu Jan  8 17:29:14 2026

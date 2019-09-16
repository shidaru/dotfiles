;;; package --- Emacs configs -*- coding: utf-8 ; lexical-binding: t -*-

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;;; Code:
(require 'cl)

;; C-hでBackSpace
(keyboard-translate ?\C-h ?\C-?)

;; Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;
;; Appearance --
;;

;; theme
(straight-use-package
 '(zenburn :type git :host github :repo "bbatsov/zenburn-emacs"))
(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

;; ツールバー、メニューバーの非表示
(tool-bar-mode 0)
(menu-bar-mode 0)
;; OS標準のスクロールバーを消す
(scroll-bar-mode -1)
;; 起動時にスタートアップ画面を表示しない
(setq inhibit-startup-message t)
;; カーソル行に下線を表示
(defvar hl-line-face 'underline)
(global-hl-line-mode)
;; カーソルの位置が何文字目かを表示する
(column-number-mode t)
;; カーソルの位置が何行目かを表示する
(line-number-mode t)
;; バッファの左側に行番号を表示する
(global-display-line-numbers-mode)

;; font --
(create-fontset-from-ascii-font
 "Ricty Diminished-15"
 nil
 "ricty")
(set-fontset-font
 "fontset-ricty"
 'unicode
 "Ricty Diminished-15"
 nil
 'append)
(add-to-list 'default-frame-alist '(font . "fontset-ricty"))


;;
;; Basic --
;;

;; デフォルトのタブ幅を4にする
(setq default-tab-width 4)
;; auto-fill-modeを使用しない
(defvar auto-fill-mode nil)
;;; パスワードを表示させないための設定
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)
;;警告音を消す
(setq visible-bell t)
;; file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)
;; インクリメンタルサーチ時には大文字小文字の区別をしない
(setq isearch-case-fold-search t)
;; バッファー名の問い合わせで大文字小文字の区別をしない
(setq read-buffer-completion-ignore-case t)
;; ファイル名の問い合わせで大文字小文字の区別をしない
(setq read-file-name-completion-ignore-case t)
;; バッファ自動再読み込み
(global-auto-revert-mode 1)
;; 1行づつスクロールする
(setq scroll-conservatively 1)
;; リージョンを色付きにする
(transient-mark-mode 1)
;; 保存時に行末の空白を消す
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; 行末の空白をハイライト
(setq-default show-trailing-whitespace t)
;; 対応する括弧を自動で挿入
(electric-pair-mode 1)
;; カッコの強調
(show-paren-mode t)
;; カッコの色付け
(use-package rainbow-delimiters
  :config
  (use-package cl-lib)
  (use-package color)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (rainbow-delimiters-mode 1)
  (setq rainbow-delimiters-outermost-only-face-count 1)
  )
;; ファイルの最後に改行を挿入する
(setq require-final-newline t)
;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)

;; recentf
(defvar recentf-max-saved-items 100) ;; 100ファイルまで履歴保存する
(defvar recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
(defvar recentf-exclude '("\\.recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/" ".emacs.d/straight"))
(defvar recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
(setq recentf-keep '(file-remote-p file-readable-p))
(recentf-mode 1)

;; Language --
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(use-package mozc
  :config
  (setq mozc-candidate-style 'echo-area)
  (setq default-input-method "japanese-mozc")
  (add-hook 'input-method-activate-hook
	    (lambda() (set-cursor-color "pink")))
  (add-hook 'input-method-inactivate-hook
	    (lambda() (set-cursor-color "black")))
  (global-set-key (kbd "C-j") 'toggle-input-method)
  )

;;
;; Commands --
;;

;; Window 分割・移動を C-t で
(defun other-window-or-split ()
  "Window split easily."
  (interactive)
  (when (one-window-p)
    (if (>= (window-body-width) 270)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)

;; 句読点をコマンドでカンマ、ピリオドに変換する
;; M-x r-p-o RET で「、。」に，M-x r-p-, RET で「，。」に，M-x r-p-. RET で「，．」に，変換する
;; リージョン指定をしていなければ，バッファ全体を変換対象とする
(defun replace-punctuation (a1 a2 b1 b2)
  "Replace periods and commas A1 A2 B1 B2."
  (let ((s1 (if mark-active "選択領域" "バッファ全体"))
        (s2 (concat a2 b2))
        (b (if mark-active (region-beginning) (point-min)))
        (e (if mark-active (region-end) (point-max))))
    (if (y-or-n-p (concat s1 "の句読点を「" s2 "」にしますがよろしいですか?"))
        (progn
          (replace-string a1 a2 nil b e)
          (replace-string b1 b2 nil b e)))))
(defun replace-punctuation-ten-maru ()
  "選択領域またはバッファ全体の句読点を「、。」にします."
  (interactive)
  (replace-punctuation "，" "、" "．" "。"))
(defun replace-punctuation-comma-maru ()
  "選択領域またはバッファ全体の句読点を「，。」にします."
  (interactive)
  (replace-punctuation "、" "，" "．" "。"))
(defun replace-punctuation-comma-period ()
  "選択領域またはバッファ全体の句読点を「，．」にします."
  (interactive)
  (replace-punctuation "、" "，" "。" "．"))
(defalias 'replace-punctuation-o 'replace-punctuation-ten-maru)
(defalias 'replace-punctuation-\, 'replace-punctuation-comma-maru)
(defalias 'replace-punctuation-. 'replace-punctuation-comma-period)
(defalias 'tenmaru 'replace-punctuation-ten-maru)
(defalias 'commamaru 'replace-punctuation-comma-maru)
(defalias 'commaperiod 'replace-punctuation-comma-period)

;; 全行一括インデントを行う
(defun all-indent ()
  "Indent current buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max))))

(defun electric-indent ()
  "Indent specified region.
When resion is active, indent region.
Otherwise indent whole buffer."
  (interactive)
  (if (use-region-p)
      (indent-region (region-beginning) (region-end))
    (all-indent)))
(global-set-key (kbd "C-M-\\") 'electric-indent)

;;
;; Interfaces --
;;

(use-package neotree
  :config
  ;; 隠しファイルをデフォルトで表示
  (setq neo-show-hidden-files t)
  ;; cotrol + q でneotreeを起動
  (global-set-key "\C-q" 'neotree-toggle)
  (setq neo-theme 'ascii)
  (setq neo-persist-show t) ;; delete-other-window で neotree ウィンドウを消さない
  (setq neo-smart-open t) ;; neotree ウィンドウを表示する毎に current file のあるディレクトリを表示する
  )

;; 同名ファイルのバッファ名の識別文字列を変更する
(use-package uniquify
  :straight nil
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  )

;; 履歴
(use-package undo-tree
  :diminish
  (undo-tree-mode)
  :config
  (global-undo-tree-mode t)
  (global-set-key (kbd "M-/") 'undo-tree-redo)
  )
(use-package undohist
  :config
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG" "/EDITMSG" "/straignt"))
  (undohist-initialize)
  )

;; リージョン範囲を簡単に変更
(use-package expand-region
  :bind
  (("C-." . 'er/expand-region)
   ("C-M-." . 'er/contract-region))
  :config
  (transient-mark-mode t) ;; transient-mark-modeが nilでは動作しない
  )

;; 行頭とコードの先頭・行末とコードの末尾を行き来できるようにする
(use-package mwim
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
   ("C-e" . mwim-end-of-code-or-line))
  :config
  (mwim-beginning-of-code-or-line)
  (mwim-beginning-of-line-or-code)
  (mwim-end-of-code-or-line)
  (mwim-end-of-line-or-code)
  )

;; comment
(use-package comment-dwim-2
  :config
  (global-set-key (kbd "M-;") 'comment-dwim-2)
  )

(use-package tramp
  :straight nil
  :config
  (setq tramp-default-method "scp")
  (let ((process-environment tramp-remote-process-environment))
    (setenv "LC_ALL" nil)
    (setenv "LC_CTYPE" nil)
    (setq tramp-remote-process-environment process-environment))
  )

;;
;; Search & Complete --
;;

;; ローマ字検索
(use-package migemo
  :config
  (setq migemo-command "/usr/bin/cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  ;; Set your installed path
  (setq migemo-dictionary
	(expand-file-name "/usr/share/cmigemo/utf-8/migemo-dict"))
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (migemo-init)
  )

(use-package helm
  :bind
  (("M-x" . helm-M-x)
   ("C-;" . helm-mini)
   ("M-y" . helm-show-kill-ring)
   ("C-x C-r" . helm-recentf))
  :config
  (helm-mode 1)
  (helm-migemo-mode t))
(use-package helm-ag
  :config
  (setq helm-ag-base-command "ac --nocolor --nogroup --ignore-case")
  (setq helm-ag-thing-at-point 'symbol))
(use-package helm-swoop
  :bind (("C-s" . helm-swoop))
  :config (setq helm-swoop-pre-input-function (lambda () nil)))

;;
;; Development --
;;

(use-package f)
(defun set-pyenv-version-path ()
  "Automatically activates pyenv version if .python-version file exists."
  (f-traverse-upwards
   (lambda (path)
     (let ((pyenv-version-path (f-expand ".python-version" path)))
       (if (f-exists? pyenv-version-path)
           (pyenv-mode-set (s-trim (f-read-text pyenv-version-path 'utf-8))))))))
(provide 'set-pyenv-version-path)
(require 'set-pyenv-version-path)
(add-hook 'find-file-hook 'set-pyenv-version-path)
(add-to-list 'exec-path "~/.pyenv/shims")
(use-package python-black
  :demand t
  :after python)
(use-package cython-mode
  :mode (("\\.pyx\\'" . cython-mode))
  )

(use-package kotlin-mode
  :mode (("\\.kt\\'" . kotlin-mode)))

;; 定型文挿入
(use-package yasnippet
  :diminish yas-minor-mode
  :bind (
	 ;; 新規スニペットを作成するバッファを用意する
	 ("C-x y n" . yas-new-snippet)
	 ;; 既存スニペットを閲覧・編集する
	 ("C-x y v" . yas-visit-snippet-file))
  :config
  (yas-global-mode 1)
  )
(use-package helm-c-yasnippet
  :bind
  (("C-c y" . helm-yas-complete))
  :config
  (setq helm-yas-space-match-any-greedy t)
  (yas-load-directory "~/.emacs.d/snippets/"))

(use-package markdown-mode
  :mode (("\\md?\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package dumb-jump
  :bind (("M-d" . dumb-jump-go))
  :config
  (setq dumb-jump-mode t)
  (setq dumb-jump-selector 'helm) ;; 候補選択をivyに任せます
  (setq dumb-jump-use-visible-window nil)
  ;; これをしないとホームディレクトリ以下が検索対象になる
  (setq dumb-jump-default-project "")
  ;; 日本語を含むパスだとgit grepがちゃんと動かない
  (setq dumb-jump-force-searcher 'ag)
  ;; 標準キーバインドを有効にする
  (dumb-jump-mode)
  )

;; Dockerfile
(use-package dockerfile-mode
  :mode (("\\Dockerfile?\\'" . dockerfile-mode)))

;; yaml
(use-package yaml-mode
  :mode (("\\.yml?\\'" . yaml-mode)))

;; 構文チェック
(use-package flycheck
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  )

;; ;; TeX
;; (use-package yatex
;;   :ensure t
;;   :mode (("\\.tex?\\'" . yatex-mode))
;;   :bind (("C-c C-t" . YaTeX-typeset-menu))
;;   :config
;;   ;; variables are declared in yatexlib.el
;;   (setq YaTeX-inhibit-prefix-letter t)
;;   ;; local dictionary is NOT needed
;;   (setq YaTeX-nervous nil)

;;   ;; variables are declared in yatex.el
;;   (setq tex-command "ptex2pdf -l -u")
;;   (setq bibtex-command "pbibtex")
;;   (setq tex-pdfview-command "evince")
;;   (setq YaTeX-simple-messages t)
;;   (setq YaTeX-skip-default-reader t)

;; ;; org-mode
;; (use-package org
;;   :mode (("\\.org?\\'" . org-mode))
;;   :config
;;   (define-key org-mode-map (kbd "C-j") nil)
;;   ;;; \hypersetup{...} を出力しない
;;   (setq org-latex-with-hyperref nil)

;;   (use-package org-bullets
;;     :ensure t
;;     :config
;;     (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;     )
;;   (use-package htmlize
;;     :ensure t
;;     )
;;   ;; そのコード用のモードと同じ色でハイライト表示する
;;   (setq org-src-fontify-natively t)
;;   ;; Validatのリンクを消す
;;   (defvar org-html-validation-link nil)
;;   ;; スピードコマンドを有効化する
;;   (setq org-use-speed-commands t)
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    '((R . t)
;;      (C . t)
;;      (python . t)
;;      (gnuplot . t)
;;      (emacs-lisp . nil)
;;      (plantuml . t)
;;      (dot . t)
;;      (latex . t)
;;      (ditaa . t)
;;      ))

;;   (use-package ox-bibtex)
;;   (use-package org-ref
;;     :ensure t
;;     :disabled
;;     :config
;;     (setq reftex-default-bibliography '("~/Documents/Research/docs/references.bib"))
;; 	;;; migemo を有効化
;;     (push '(migemo) helm-source-bibtex)
;;     ;; ノート、bib ファイル、PDF のディレクトリなどを設定
;;     (setq org-ref-default-bibliography "~/Documents/Research/docs/references.bib")
;; 	;;; helm-bibtex を使う場合は以下の変数も設定しておく
;;     (setq bibtex-completion-bibliography "~/Documents/Research/docs/references.bib")
;; 	;;; background が暗い色だとリンクの色が見辛い
;;     (set-face-foreground 'org-ref-cite-face "White")
;;     (set-face-foreground 'org-ref-ref-face "Yellow")
;;     (set-face-foreground 'org-ref-label-face "Cyan")
;;     )

;;   (use-package ox-latex
;;     :config
;;     (setq org-latex-default-class "jsarticle")
;;     (setq org-beamer-outline-frame-title "目次")

;;     (setq org-latex-pdf-process
;;     	  '("ptex2pdf -u -l -ot '-synctex=1' %f"
;; 	    "pibtex %b"
;; 	    "ptex2pdf -u -l -ot '-synctex=1' %f"
;; 	    "ptex2pdf -u -l -ot '-synctex=1' %f"))

;;     (setq org-file-apps
;; 	  '(("pdf" . "evince %s")))

;;     (add-to-list 'org-latex-classes
;; 		 '("jsarticle"
;; 		   "\\documentclass[uplatex,dvipdfmx]{jsarticle}
;;                         [NO-PACKAGES]
;;                         [NO-DEFAULT-PACKAGES]
;;                         \\usepackage{amsmath}
;; 			\\usepackage[dvipdfmx]{graphicx,color}
;; 			\\usepackage[dvipdfmx]{hyperref}
;; 			\\usepackage{pxjahyper}
;; 			\\usepackage{longtable}
;; 			\\usepackage[noalphabet]{pxchfon}
;; 			\\hypersetup{setpagesize=false,colorlinks=true}"
;; 		   ("\\section{%s}" . "\\section*{%s}")
;; 		   ("\\subsection{%s}" . "\\subsection*{%s}")
;; 		   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;; 		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
;; 		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;;     ;; thesis
;;     (add-to-list 'org-latex-classes
;; 		 '("thesis"
;; 		   "\\documentclass[uplatex,dvipdfmx]{jsarticle}
;;                         [NO-PACKAGES]
;;                         [NO-DEFAULT-PACKAGES]
;;                         \\usepackage{graphicx}
;; 		        \\usepackage{amsmath}
;; 		        \\usepackage{newtxtext,newtxmath}
;; 		        \\usepackage[dvipdfmx]{hyperref}
;; 		        \\usepackage{pxjahyper}
;; 		        \\usepackage{longtable}
;; 		        \\usepackage[noalphabet]{pxchfon}"
;; 		   ("\\section{%s}" . "\\section*{%s}")
;; 		   ("\\subsection{%s}" . "\\subsection*{%s}")
;; 		   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;; 		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
;; 		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;;     ;; beamer
;;     (add-to-list 'org-latex-classes
;; 		 '("beamer"
;; 		   "\\documentclass[uplatex,dvipdfmx]{beamer}
;;                         [PACKAGES]
;;                         [NO-DEFAULT-PACKAGES]
;;                         [EXTRA]
;; 			\\usepackage{amsmath}
;; 			\\usepackage{graphicx}
;; 			\\usepackage{color}
;; 			\\usepackage{newtxtext,newtxmath}
;; 			\\usepackage{pxjahyper}
;; 			\\usepackage[noalphabet]{pxchfon}"
;; 		   ("\\section\{%s\}" . "\\section*\{%s\}")
;; 		   ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
;; 		   ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;;     )
;;   )


;; html, css
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.css?\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-comment-style 2)
  )

(use-package php-mode
  :mode (("\\.php?\\'" . php-mode))

  )

;; javascript
(use-package js2-mode
  :mode (("\\.js?\\'" . js2-mode))
  :config
  (setq my-js-mode-indent-num 2)
  (setq js2-basic-offset my-js-mode-indent-num)
  (setq js-switch-indent-offset my-js-mode-indent-num))


(provide 'init)

;;; init.el ends here

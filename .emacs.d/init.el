;;; package --- Emacsの初期設定 -*- coding: utf-8 ; lexical-binding: t -*-

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;;; Code:

;;  基本設定 ;;;;;

;; proxy設定
;; elisp/myproxy.elがあるときだけプロキシ設定をロード
;; 第2引数のtをつけると、ファイルが存在しなくてもエラーにならない
;; (load "myproxy" t)

(require 'cl)

;; パッケージ管理
(require' package)
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "http://melpa.org/packages/")
	("org" . "http://orgmode.org/elpa/")))

(add-to-list 'load-path "~/.emacs.d/use-package")
(require 'use-package)
(use-package diminish
  :ensure t)

;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  "Add load path include sub directory.
PATHS is you want to include."
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; ディレクトリをサブディレクトリごとload-pathに追加
;; (add-to-load-path "elisp/")

;; C-hでBackSpace
(keyboard-translate ?\C-h ?\C-?)

;; 指定した行数の行に飛ぶ
(global-set-key (kbd "\C-xl") 'goto-line)

;; 端末以外から開いた場合もshellのパスを引き継ぐ
(use-package exec-path-from-shell
  :ensure t
  :demand t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

;; emacsの外観  =====================================

;; ツールバー、メニューバーの非表示
(tool-bar-mode 0)
(menu-bar-mode 0)

;; 透明度
;; (set-frame-parameter nil 'alpha 80)

;;; パスワードを表示させないための設定
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; デフォルトのタブ幅を4にする
(setq default-tab-width 4)
;; auto-fill-modeを使用しない
(defvar auto-fill-mode nil)

;; モードラインに時間表示 月/日 曜日
(defvar display-time-string-forms '(year "/" month "/" day " (" dayname ") " 24-hours ":" minutes))

;; 起動時にスタートアップ画面を表示しない
(setq inhibit-startup-message t)

;; カーソル行に下線を表示
(defvar hl-line-face 'underline)
(global-hl-line-mode)

;; フルスクリーン
;; (set-frame-parameter nil 'fullscreen 'fullboth)

;; 言語環境
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; mozc
(use-package mozc
  :ensure t
  :config
  (setq mozc-candidate-style 'echo-area)
  (setq default-input-method "japanese-mozc")
  (add-hook 'input-method-activate-hook
	    (lambda() (set-cursor-color "pink")))
  (add-hook 'input-method-inactivate-hook
	    (lambda() (set-cursor-color "black")))
  (global-set-key (kbd "C-j") 'toggle-input-method)
  )

;;フォント設定 ===============================================
(create-fontset-from-ascii-font
 "Ricty Diminished-12.0"
 nil
 "ricty")

(set-fontset-font
 "fontset-ricty"
 'unicode
 "Ricty Diminished-12.0"
 nil
 'append)

(add-to-list 'default-frame-alist '(font . "fontset-ricty"))
;; ===========================================================

;; OS標準のスクロールバーを消す
(scroll-bar-mode -1)

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;;警告音を消す
(setq visible-bell t)

;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;; カーソルの位置が何行目かを表示する
(line-number-mode t)

;; バッファの左側に行番号を表示する
(cond ((fboundp 'global-display-line-numbers-mode)
       (global-display-line-numbers-mode))
      (t
       (use-package nlinum
	 :config
	 (global-nlinum-mode t)
	 ;; 5 桁分の表示領域を確保する
	 (defvar nlinum-format "%5d ")
	 )))

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

;; カッコの強調
(show-paren-mode t)

;; ファイルの最後に改行を挿入する
(setq require-final-newline t)

;; 対応する括弧を自動で挿入
(electric-pair-mode 1)

;; recentf
(defvar recentf-max-saved-items 500) ;; 500ファイルまで履歴保存する
(defvar recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
(defvar recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/"))
(defvar recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
(recentf-mode 1)

;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

;; 基本設定終了 ;;;;;

;; インターフェース設定 ;;;;;

(use-package magit
  :ensure
  :bind("C-x g" . magit-status)
  )

(use-package neotree
  :ensure t
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
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  )

;; マウス操作を禁じる
(use-package disable-mouse
  :diminish ""
  :ensure t
  :config
  (global-disable-mouse-mode)
  )

;; mode-line
(use-package telephone-line
  :config
  (setq telephone-line-primary-left-separator 'telephone-line-cubed-left
	telephone-line-secondary-left-separator 'telephone-line-cubed-hollow-left
	telephone-line-primary-right-separator 'telephone-line-cubed-right
	telephone-line-secondary-right-separator 'telephone-line-cubed-hollow-right)
  (setq telephone-line-height 24
	telephone-line-evil-use-short-tag t)
  (telephone-line-mode 1)
  )

;; カッコの色付け
(use-package rainbow-delimiters
  :ensure t
  :config
  (use-package cl-lib)
  (use-package color)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (rainbow-delimiters-mode 1)
  (setq rainbow-delimiters-outermost-only-face-count 1)
  )

;; 履歴
(use-package undo-tree
  :ensure t
  :diminish
  (undo-tree-mode)
  :config
  (global-undo-tree-mode t)
  (global-set-key (kbd "M-/") 'undo-tree-redo)
  )

(use-package undohist
  :ensure t
  :config
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG" "/EDITMSG" "/elpa" "/elisp"))
  (undohist-initialize)
  )

;; リージョン範囲を簡単に変更
(use-package expand-region
  :ensure t
  :bind
  (("C-." . 'er/expand-region)
   ("C-M-." . 'er/contract-region))
  :config
  (transient-mark-mode t) ;; transient-mark-modeが nilでは動作しない
  )

;; 行頭とコードの先頭・行末とコードの末尾を行き来できるようにする
(use-package mwim
  :ensure t
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
   ("C-e" . mwim-end-of-code-or-line))
  :config
  (mwim-beginning-of-code-or-line)
  (mwim-beginning-of-line-or-code)
  (mwim-end-of-code-or-line)
  (mwim-end-of-line-or-code)
  )

;; ローマ字検索
(use-package migemo
  :ensure t
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

;; 検索・補完インターフェース
(defun ivy-rich-switch-buffer-icon (candidate)
  (with-current-buffer
      (get-buffer candidate)
    (let ((icon (all-the-icons-icon-for-mode major-mode)))
      (if (symbolp icon)
	  (all-the-icons-icon-for-mode 'fundamental-mode)
	icon))))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 30) ;; minibufferのサイズ
  (setq ivy-extra-directories nil)
  (setq ivy-re-builders-alist
	'((t . ivy--regex-plus)))

  (use-package ivy-rich
    :config
    (ivy-rich-mode 1)
    (setq ivy-rich--display-transformers-list
	  (plist-put ivy-rich--display-transformers-list
		     'ivy-switch-buffer
		     '(:columns
		       ((ivy-rich-switch-buffer-icon :width "2")
			(ivy-rich-candidate (:width 30))
			(ivy-rich-switch-buffer-size (:width 7))
			(ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
			(ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
			(ivy-rich-switch-buffer-project (:width 15 :face success))
			(ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
		       :predicate
		       (lambda (cand) (get-buffer cand)))))
    )
  ;; counsel設定
  (defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
  (use-package swiper
    :ensure t
    :bind
    ("\C-s" . swiper)
    )
  (defvar swiper-include-line-number-in-search t) ;; line-numberでも検索可能
  ;; migemo + swiper（日本語をローマ字検索できるようになる）
  (use-package avy-migemo
    :ensure t
    :config
    (avy-migemo-mode 1)
    (use-package avy-migemo-e.g.swiper)
    )
  (use-package ivy-yasnippet
    :ensure t
    :bind (("C-c y" . ivy-yasnippet))
    )
  )


;; 使い捨てファイルを開く
(use-package open-junk-file
  :ensure t
  :config
  (setq open-junk-file-format "~/local/Junks/%Y-%m%d-%H%M%S.")
  (global-set-key "\C-xj" 'open-junk-file)
  )

(use-package tramp
  :config
  (use-package tramp-sh)
  (setq tramp-default-method "scp")
  (let ((process-environment tramp-remote-process-environment))
    (setenv "LC_ALL" nil)
    (setenv "LC_CTYPE" nil)
    (setq tramp-remote-process-environment process-environment))
  )

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

(use-package twittering-mode
  :config
  ;; 簡単ログインの設定
  (setq twittering-allow-insecure-server-cert t)
  (setq twittering-use-master-password t)
  ;; (setq twittering-private-info-file "~/.emacs.d/twittering-mode.gpg")
  ;; (setq twittering-status-format "%i @%s %S %p: n %T  [%@]%r %R %f%Ln ------------------------------" )
  )

;; インターフェース設定終了

;; 開発環境設定

;; コード補完
(use-package company
  :ensure t
  :diminish
  :config
  (global-company-mode)
  (setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
  (setq company-idle-delay 0) ; 遅延なしにすぐ表示
  (setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
  (define-key company-active-map (kbd "C-h") nil) ;; C-hはバックスペース割当のため無効化

  ;; 未選択項目
  (set-face-attribute 'company-tooltip nil
                      :foreground "#36c6b0" :background "#244f36")
  ;; 未選択項目&一致文字
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "white" :background "#244f36")
  ;; 選択項目
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "#a1ffcd" :background "#007771")
  ;; 選択項目&一致文字
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "#007771")
  ;; スクロールバー
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "#4cd0c1")
  ;; スクロールバー背景
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "#002b37")
  )

;; 構文チェック
(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  )

;; 定型文挿入
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :bind (
	 ;; 既存スニペットを挿入する
	 ("C-x y i" . yas-insert-snippet)
	 ;; 新規スニペットを作成するバッファを用意する
	 ("C-x y n" . yas-new-snippet)
	 ;; 既存スニペットを閲覧・編集する
	 ("C-x y v" . yas-visit-snippet-file)
	 ("C-x y l" . yas-describe-tables)
	 ("C-x y g" . yas-reload-all))
  :config
  (use-package yasnippet-snippets
    :ensure t
    )
  (yas-global-mode 1)
  )

;; anzu
(use-package anzu
  :ensure t
  :diminish ""
  :config
  (global-anzu-mode +1)
  )

;; Python
(use-package python-mode
  :ensure t
  :config
  (define-key python-mode-map (kbd "C-j") nil)
  )

;; TeX
(use-package yatex
  :ensure t
  :mode (("\\.tex?\\'" . yatex-mode))
  :bind (("C-c C-t" . YaTeX-typeset-menu))
  :config
  ;; variables are declared in yatexlib.el
  (setq YaTeX-inhibit-prefix-letter t)
  ;; local dictionary is NOT needed
  (setq YaTeX-nervous nil)

  ;; variables are declared in yatex.el
  (setq tex-command "ptex2pdf -l -u")
  (setq bibtex-command "pbibtex")
  (setq tex-pdfview-command "evince")
  (setq YaTeX-simple-messages t)
  (setq YaTeX-skip-default-reader t)

  ;; yatex上で数式をプレビューする
  (use-package latex-math-preview
    :ensure t
    )
  (setq latex-math-preview-command-path-alist
	'((latex . "/usr/bin/uplatex") (dvipng . "/usr/bin/dvipng") (dvips . "/usr/bin/dvips")))
  (autoload 'latex-math-preview-expression "latex-math-preview" nil t)
  (autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
  (autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)
  (autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
  (add-hook 'yatex-mode-hook
	    '(lambda ()
	       (YaTeX-define-key "p" 'latex-math-preview-expression)
	       (YaTeX-define-key "\C-p" 'latex-math-preview-save-image-file)
	       (YaTeX-define-key "j" 'latex-math-preview-insert-symbol)
	       (YaTeX-define-key "\C-j" 'latex-math-preview-last-symbol-again)
	       (YaTeX-define-key "\C-b" 'latex-math-preview-beamer-frame)))
  (defvar latex-math-preview-in-math-mode-p-func 'YaTeX-in-math-mode-p)
  )

;; Comment
(use-package comment-dwim-2
  :ensure t
  :config
  (global-set-key (kbd "M-;") 'comment-dwim-2)
  )

;; org-mode
(use-package org
  :mode (("\\.org?\\'" . org-mode))
  :config
  (define-key org-mode-map (kbd "C-j") nil)
  ;;; \hypersetup{...} を出力しない
  (setq org-latex-with-hyperref nil)

  (use-package org-bullets
    :ensure t
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    )
  (use-package htmlize
    :ensure t
    )
  ;; そのコード用のモードと同じ色でハイライト表示する
  (setq org-src-fontify-natively t)
  ;; Validatのリンクを消す
  (defvar org-html-validation-link nil)
  ;; スピードコマンドを有効化する
  (setq org-use-speed-commands t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((R . t)
     (C . t)
     (python . t)
     (gnuplot . t)
     (emacs-lisp . nil)
     (plantuml . t)
     (dot . t)
     (latex . t)
     (ditaa . t)
     ))

  (use-package ox-bibtex)
  (use-package org-ref
    :ensure t
    :disabled
    :config
    (setq reftex-default-bibliography '("~/Documents/Research/docs/references.bib"))
	;;; migemo を有効化
    (push '(migemo) helm-source-bibtex)
    ;; ノート、bib ファイル、PDF のディレクトリなどを設定
    (setq org-ref-default-bibliography "~/Documents/Research/docs/references.bib")
	;;; helm-bibtex を使う場合は以下の変数も設定しておく
    (setq bibtex-completion-bibliography "~/Documents/Research/docs/references.bib")
	;;; background が暗い色だとリンクの色が見辛い
    (set-face-foreground 'org-ref-cite-face "White")
    (set-face-foreground 'org-ref-ref-face "Yellow")
    (set-face-foreground 'org-ref-label-face "Cyan")
    )

  (use-package ox-latex
    :config
    (setq org-latex-default-class "jsarticle")
    (setq org-beamer-outline-frame-title "目次")

    (setq org-latex-pdf-process
    	  '("ptex2pdf -u -l -ot '-synctex=1' %f"
	    "pibtex %b"
	    "ptex2pdf -u -l -ot '-synctex=1' %f"
	    "ptex2pdf -u -l -ot '-synctex=1' %f"))

    (setq org-file-apps
	  '(("pdf" . "evince %s")))

    (add-to-list 'org-latex-classes
		 '("jsarticle"
		   "\\documentclass[uplatex,dvipdfmx]{jsarticle}
                        [NO-PACKAGES]
                        [NO-DEFAULT-PACKAGES]
                        \\usepackage{amsmath}
			\\usepackage[dvipdfmx]{graphicx,color}
			\\usepackage[dvipdfmx]{hyperref}
			\\usepackage{pxjahyper}
			\\usepackage{longtable}
			\\usepackage[noalphabet]{pxchfon}
			\\hypersetup{setpagesize=false,colorlinks=true}"
		   ("\\section{%s}" . "\\section*{%s}")
		   ("\\subsection{%s}" . "\\subsection*{%s}")
		   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

    ;; thesis
    (add-to-list 'org-latex-classes
		 '("thesis"
		   "\\documentclass[uplatex,dvipdfmx]{jsarticle}
                        [NO-PACKAGES]
                        [NO-DEFAULT-PACKAGES]
                        \\usepackage{graphicx}
		        \\usepackage{amsmath}
		        \\usepackage{newtxtext,newtxmath}
		        \\usepackage[dvipdfmx]{hyperref}
		        \\usepackage{pxjahyper}
		        \\usepackage{longtable}
		        \\usepackage[noalphabet]{pxchfon}"
		   ("\\section{%s}" . "\\section*{%s}")
		   ("\\subsection{%s}" . "\\subsection*{%s}")
		   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

    ;; beamer
    (add-to-list 'org-latex-classes
		 '("beamer"
		   "\\documentclass[uplatex,dvipdfmx]{beamer}
                        [PACKAGES]
                        [NO-DEFAULT-PACKAGES]
                        [EXTRA]
			\\usepackage{amsmath}
			\\usepackage{graphicx}
			\\usepackage{color}
			\\usepackage{newtxtext,newtxmath}
			\\usepackage{pxjahyper}
			\\usepackage[noalphabet]{pxchfon}"
		   ("\\section\{%s\}" . "\\section*\{%s\}")
		   ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
		   ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

    )
  )

(use-package markdown-mode
  :ensure t
  :mode (("\\md?\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  )

(use-package eww
  :config
  (bind-keys :map eww-mode-map
             ("h" . backward-char)
             ("j" . next-line)
             ("k" . previous-line)
             ("l" . forward-char)
             ("J" . View-scroll-line-forward)  ;; カーソルは移動せず、画面がスクロースする
             ("K" . View-scroll-line-backward)
             ("s-[" . eww-back-url)
             ("s-]" . eww-forward-url)
             ("s-{" . previous-buffer)
             ("s-}" . next-buffer)
             )
  )

(use-package dumb-jump
  :ensure t
  :config
  ;; これをしないとホームディレクトリ以下が検索対象になる
  (setq dumb-jump-default-project "")
  ;; 日本語を含むパスだとgit grepがちゃんと動かない
  (setq dumb-jump-force-searcher 'rg)
  ;; 標準キーバインドを有効にする
  (dumb-jump-mode)
  )

;; Shell Script
(setq sh-basic-offset 2)
(setq sh-indentation 2)
(setq sh-shell-file "/bin/sh")

;; Dockerfile
(use-package dockerfile-mode
  :ensure t
  :mode (("\\Dockerfile?\\'" . dockerfile-mode))
  )

;; yaml
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml?\\'" . yaml-mode))
  )

;; web全般
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.js?\\'" . web-mode)
	 ("\\.css?\\'" . web-mode)
	 )
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-comment-style 2)
  )

;; Golang
;; goへのパス
(add-to-list 'exec-path (expand-file-name "~/local/go/bin/"))
;; go get で入れたツールへのパス
(add-to-list 'exec-path (expand-file-name "~/.go/bin/"))
(use-package go-mode
  :ensure t
  :config
  (use-package go-eldoc
    :ensure t
    :config
    (add-hook 'go-mode-hook 'go-eldoc-setup))
  (bind-keys :map go-mode-map
	     ("M-." . godef-jump)
	     ("M-," . pop-tag-mark))
  (add-hook 'go-mode-hook '(lambda () (setq tab-width 4)))
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (use-package company-go
    :ensure t)
  )

;; 開発環境設定終了 ;;;;;

(provide 'init)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-migemo-function-names
   (quote
    (swiper--add-overlays-migemo
     (swiper--re-builder :around swiper--re-builder-migemo-around)
     (ivy--regex :around ivy--regex-migemo-around)
     (ivy--regex-ignore-order :around ivy--regex-ignore-order-migemo-around)
     (ivy--regex-plus :around ivy--regex-plus-migemo-around)
     ivy--highlight-default-migemo ivy-occur-revert-buffer-migemo ivy-occur-press-migemo avy-migemo-goto-char avy-migemo-goto-char-2 avy-migemo-goto-char-in-line avy-migemo-goto-char-timer avy-migemo-goto-subword-1 avy-migemo-goto-word-1 avy-migemo-isearch avy-migemo-org-goto-heading-timer avy-migemo--overlay-at avy-migemo--overlay-at-full)))
 '(package-selected-packages
   (quote
    (telephone-line twittering-mode meghanada yatex yasnippet-snippets yaml-mode web-mode undohist undo-tree swiper spinner rainbow-delimiters python-mode py-yapf org-bullets open-junk-file nlinum neotree mwim mozc markdown-mode magit latex-math-preview ivy-yasnippet ivy-rich htmlize ht highlight-indentation helm-swoop helm-migemo google-translate go-eldoc flycheck find-file-in-project expand-region exec-path-from-shell epc dumb-jump dockerfile-mode disable-mouse diminish dash-functional company-go comment-dwim-2 avy-migemo anzu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

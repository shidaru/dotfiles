;;; package --- Emacs configs -*- coding: utf-8 ; lexical-binding: t -*-

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;;; Code:
(require 'cl)

(require 'package)
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "http://melpa.org/packages/")
	("org" . "http://orgmode.org/elpa/")))
(unless package-archive-contents
  (package-refresh-contents))
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)

;; C-hでBackSpace
(keyboard-translate ?\C-h ?\C-?)

;;
;; Appearance --
;;

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
(if (window-system)
    (progn
      (create-fontset-from-ascii-font
       "Fira Code Medium-10.5"
       nil
       "own")
      (set-fontset-font
       "fontset-own"
       'unicode
       "Fira Code Medium-10.5"
       nil
       'append)
      (add-to-list 'default-frame-alist '(font . "fontset-own"))
      ))

;; color-theme
(load-theme 'snow t t)
(enable-theme 'snow)

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
(use-package smooth-scroll
  :ensure t
  :config
  (smooth-scroll-mode t)
  )
;; リージョンを色付きにする
(transient-mark-mode 1)
;; 保存時に行末の空白を消す
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; 行末の空白をハイライト
(setq-default show-trailing-whitespace t)
(use-package highlight-symbol
  :ensure t
  :config
  (setq highlight-symbol-colors '("LightSeaGreen" "HotPink" "SlateBlue1" "DarkOrange" "SpringGreen1" "tan" "DodgerBlue1"))
  (global-set-key (kbd "C-x C-l") 'highlight-symbol-at-point)
  )
;; 対応する括弧を自動で挿入
(electric-pair-mode 1)
;; カッコの強調
(show-paren-mode t)
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
(use-package telephone-line
  :ensure t
  :config
  ;; set faces
  (defface level1-active
    '((t (:foreground "black" :background "SpringGreen" :inherit mode-line))) "")
  (defface level1-inactive
    '((t (:foreground "white" :background "grey11" :inherit mode-line-inactive))) "")
  (defface level2-active
    '((t (:foreground "black" :background "royal blue" :inherit mode-line))) "")
  (defface level2-inactive
    '((t (:foreground "back" :background "grey11" :inherit mode-line-inactive))) "")
  (defface level3-active
    '((t (:foreground "gray" :background "dark cyan" :inherit mode-line))) "")
  (defface level3-inactive
    '((t (:foreground "white" :background "grey11" :inherit mode-line-inactive))) "")

  (setq telephone-line-faces
      (append '((level1 . (level1-active . level1-inactive))
                (level2 . (level2-active . level2-inactive))
                (level3 . (level3-active . level3-inactive))
                ) telephone-line-faces)
      )

  ;; 左側で表示するコンテンツの設定
  (setq telephone-line-lhs
	'((level1 . (telephone-line-major-mode-segment))
	  (level2 . (telephone-line-vc-segment
		     telephone-line-erc-modified-channels-segment
		     telephone-line-process-segment))
	  (nil    . (telephone-line-buffer-segment))))

  ;; 右側で表示するコンテンツの設定
  (setq telephone-line-rhs
	'((nil    . (telephone-line-misc-info-segment))
	  (level2 . nil)
	  (level1   . (telephone-line-airline-position-segment))))

  ;; Telephone Lineモードを使う設定
  (telephone-line-mode 1)
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
  :ensure t
  :config
  (setq mozc-candidate-style 'echo-area)
  (setq default-input-method "japanese-mozc")
  (add-hook 'input-method-activate-hook
	    (lambda() (set-cursor-color "green")))
  (add-hook 'input-method-inactivate-hook
	    (lambda() (set-cursor-color "orange")))
  ;; (global-set-key (kbd "C-j") 'toggle-input-method)
  ;; (define-key minibuffer-local-map (kbd "C-j") 'toggle-input-method)
  (global-set-key [henkan]
		  (lambda () (interactive)
		    (when (null current-input-method) (toggle-input-method))))
  (global-set-key [muhenkan]
		  (lambda () (interactive)
		    (inactivate-input-method)))
  ; 全角半角キーと無変換キーのキーイベントを横取りする
  (defadvice mozc-handle-event (around intercept-keys (event))
    "Intercept keys muhenkan and zenkaku-hankaku, before passing keys
to mozc-server (which the function mozc-handle-event does), to
properly disable mozc-mode."
    (if (member event (list 'zenkaku-hankaku 'muhenkan))
	(progn
	  (mozc-clean-up-session)
	  (toggle-input-method))
      (progn ;(message "%s" event) ;debug
	ad-do-it)))
  (ad-activate 'mozc-handle-event)
  )
;; 改行文字の文字列表現
(set 'eol-mnemonic-dos "(CRLF)")
(set 'eol-mnemonic-unix "(LF)")
(set 'eol-mnemonic-mac "(CR)")
(set 'eol-mnemonic-undecided "(?)")

;; 文字エンコーディングの文字列表現
(defun my-coding-system-name-mnemonic (coding-system)
  (let* ((base (coding-system-base coding-system))
         (name (symbol-name base)))
    (cond ((string-prefix-p "utf-8" name) "U8")
          ((string-prefix-p "utf-16" name) "U16")
          ((string-prefix-p "utf-7" name) "U7")
          ((string-prefix-p "japanese-shift-jis" name) "SJIS")
          ((string-match "cp\\([0-9]+\\)" name) (match-string 1 name))
          ((string-match "japanese-iso-8bit" name) "EUC")
          (t "???")
          )))

(defun my-coding-system-bom-mnemonic (coding-system)
  (let ((name (symbol-name coding-system)))
    (cond ((string-match "be-with-signature" name) "[BE]")
          ((string-match "le-with-signature" name) "[LE]")
          ((string-match "-with-signature" name) "[BOM]")
          (t ""))))

(defun my-buffer-coding-system-mnemonic ()
  "Return a mnemonic for `buffer-file-coding-system'."
  (let* ((code buffer-file-coding-system)
         (name (my-coding-system-name-mnemonic code))
         (bom (my-coding-system-bom-mnemonic code)))
    (format "%s%s" name bom)))

;; `mode-line-mule-info' の文字エンコーディングの文字列表現を差し替える
(setq-default mode-line-mule-info
              (cl-substitute '(:eval (my-buffer-coding-system-mnemonic))
                             "%z" mode-line-mule-info :test 'equal))

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

(defun region-to-single-quote ()
  (interactive)
  (quote-formater "'%s'" "^\\(\"\\).*" ".*\\(\"\\)$"))

(defun region-to-double-quote ()
  (interactive)
  (quote-formater "\"%s\"" "^\\('\\).*" ".*\\('\\)$"))

(defun region-to-bracket ()
  (interactive)
  (quote-formater "\(%s\)" "^\\(\\[\\).*" ".*\\(\\]\\)$"))

(defun region-to-square-bracket ()
  (interactive)
  (quote-formater "\[%s\]" "^\\(\(\\).*" ".*\\(\)\\)$"))

(defun quote-formater (quote-format re-prefix re-suffix)
  (if mark-active
      (let* ((region-text (buffer-substring-no-properties (region-beginning) (region-end)))
             (replace-func (lambda (re target-text)(replace-regexp-in-string re "" target-text nil nil 1)))
             (text (funcall replace-func re-suffix (funcall replace-func re-prefix region-text))))
        (delete-region (region-beginning) (region-end))
        (insert (format quote-format text)))
    (error "Not Region selection")))

(use-package region-bindings-mode
  :ensure t
  :config
  (region-bindings-mode-enable)
  (define-key region-bindings-mode-map (kbd "M-7") 'region-to-single-quote)
  (define-key region-bindings-mode-map (kbd "M-2") 'region-to-double-quote)
  (define-key region-bindings-mode-map (kbd "M-8") 'region-to-bracket)
  (define-key region-bindings-mode-map (kbd "M-[") 'region-to-square-bracket)
  )

(defun revert-buffer-no-confirm (&optional force-reverting)
  "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
  (interactive "P")
  ;;(message "force-reverting value is %s" force-reverting)
  (if (or force-reverting (not (buffer-modified-p)))
      (revert-buffer :ignore-auto :noconfirm)
    (error "The buffer has been modified")))

;; reload buffer
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

;;
;; Interfaces --
;;

(use-package neotree
  :ensure t
  :config
  ;; 隠しファイルをデフォルトで表示
  (defvar neo-show-hidden-files t)
  ;; cotrol + q でneotreeを起動
  (global-set-key "\C-q" 'neotree-toggle)
  (defvar neo-theme 'ascii)
  (defvar neo-persist-show t) ;; delete-other-window で neotree ウィンドウを消さない
  (defvar neo-smart-open t) ;; neotree ウィンドウを表示する毎に current file のあるディレクトリを表示する
  )

;; 同名ファイルのバッファ名の識別文字列を変更する
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
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
  (defvar undohist-ignored-files '("/tmp" "COMMIT_EDITMSG" "/EDITMSG" "/straignt"))
  (undohist-initialize)
  )

;; リージョン範囲を簡単に変更
(use-package expand-region
  :ensure t
  :defer t
  :bind
  (("C-." . 'er/expand-region)
   ("C-M-." . 'er/contract-region))
  :config
  (transient-mark-mode t) ;; transient-mark-modeが nilでは動作しない
  )

;; 行頭とコードの先頭・行末とコードの末尾を行き来できるようにする
(use-package mwim
  :ensure t
  :defer t
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
  :ensure t
  :config
  (global-set-key (kbd "M-;") 'comment-dwim-2)
  )

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "scp")
  (let ((process-environment tramp-remote-process-environment))
    (setenv "LC_ALL" nil)
    (setenv "LC_CTYPE" nil)
    (setq tramp-remote-process-environment process-environment))
  )

;; dired
;; diredを2つのウィンドウで開いている時に、デフォルトの移動orコピー先をもう一方のdiredで開いているディレクトリにする
(setq dired-dwim-target t)
;; ディレクトリを再帰的にコピーする
(setq dired-recursive-copies 'always)
;; diredバッファでC-sした時にファイル名だけにマッチするように
(setq dired-isearch-filenames t)

;;
;; Search & Complete --
;;

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

(use-package anzu
  :ensure t
  :config
  (global-anzu-mode +1)
  )

;; (use-package helm
;;   :bind
;;   (("M-x" . helm-M-x)
;;    ("C-;" . helm-mini)
;;    ("M-y" . helm-show-kill-ring)
;;    ("C-x C-r" . helm-recentf))
;;   :config
;;   (helm-mode 1)
;;   (helm-migemo-mode t))
;; (use-package helm-ag
;;   :config
;;   (setq helm-ag-base-command "rg -S --vimgrep --no-heading")
;;   (setq helm-ag-thing-at-point 'symbol))
;; (use-package helm-swoop
;;   :bind (("C-s" . helm-swoop))
;;   :config (setq helm-swoop-pre-input-function (lambda () nil)))

;; 定型文挿入
;; (use-package yasnippet
;;   :ensure t
;;   :defer t
;;   :diminish yas-minor-mode
;;   :bind (
;; 	 ;; 新規スニペットを作成するバッファを用意する
;; 	 ("C-x y n" . yas-new-snippet)
;; 	 ;; 既存スニペットを閲覧・編集する
;; 	 ("C-x y v" . yas-visit-snippet-file))
;;   :init
;;   (yas-global-mode 1)
;;   :custom
;;   (yas-snippet-dirs . '("~/.emacs.d/snippets"))
;;   )

(use-package company
  :ensure t
  :defer t
  ;; :defvar company-backends
  :init
  (global-company-mode)
  :config
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-h") nil)
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
  ;; バックエンド
  (add-to-list 'company-backends 'company-yasnippet)
  )

;;
;; Development --
;;

(use-package python-black
  :ensure t
  :demand t
  :after python)

;; (use-package helm-c-yasnippet
;;   :defer t
;;   :bind
;;   (("C-c y" . helm-yas-complete))
;;   :config
;;   (setq helm-yas-space-match-any-greedy t)
;;   (yas-load-directory "~/.emacs.d/snippets/"))

(use-package markdown-mode
  :defer t
  :mode (("\\md?\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; (straight-use-package
;;  '(dumb-jump :type git :host github :repo "jacktasia/dumb-jump"))
;; (use-package dumb-jump
;;   :defer t
;;   :bind (("M-d" . dumb-jump-go))
;;   :config
;;   (setq dumb-jump-mode t)
;;   (setq dumb-jump-selector 'helm) ;; 候補選択をivyに任せます
;;   (setq dumb-jump-use-visible-window nil)
;;   ;; これをしないとホームディレクトリ以下が検索対象になる
;;   (setq dumb-jump-default-project "")
;;   ;; 日本語を含むパスだとgit grepがちゃんと動かない
;;   (setq dumb-jump-force-searcher 'rg)
;;   (setq dumb-jump-rg-search-args "")
;;   )

;; Dockerfile
(use-package dockerfile-mode
  :defer t
  :mode (("\\Dockerfile?\\'" . dockerfile-mode)))

;; yaml
(use-package yaml-mode
  :defer t
  :mode (("\\.yml?\\'" . yaml-mode)))

;; 構文チェック
(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  )

;; TeX
(use-package yatex
  :defer t
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
  (add-hook 'yatex-mode-hook 'turn-on-reftex)
  )


;; 以下Org modeの設定
(use-package org
  :mode (("\\.org?\\'" . org-mode))
  :config
  (use-package org-bullets
    :ensure t
    :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  ;; (use-package org-re-reveal)
  ;; (use-package htmlize)
  (define-key org-mode-map (kbd "C-j") nil)
  ;;; \hypersetup{...} を出力しない
  (setq org-latex-with-hyperref nil)
  ;; そのコード用のモードと同じ色でハイライト表示する
  (setq org-src-fontify-natively t)
  ;; Validatのリンクを消す
  (defvar org-html-validation-link nil)
  ;; スピードコマンドを有効化する
  (setq org-use-speed-commands t)
  ;; (use-package org-tempo)
  )

;; (use-package org
;;   :straight nil
;;   :mode (("\\.org?\\'" . org-mode))
;;   :config
;;   (define-key org-mode-map (kbd "C-j") nil)
;;   ;;; \hypersetup{...} を出力しない
;;   (setq org-latex-with-hyperref nil)

;;   (straight-use-package
;;    '(org-re-reveal :type git :host gitlab :repo "oer/org-re-reveal"))
;;   (use-package org-re-reveal
;;     :mode (("\\.org?\\'" . org-mode)))

;;   (use-package org-bullets
;;     :config
;;     (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;;   (use-package htmlize)
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
  :defer t
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.css?\\'" . web-mode)
	 ("\\.php?\\'" . web-mode)
	 ("\\.js[x]?$" . web-mode))
  :config
  ;; 拡張子 .js でもJSX編集モードに
  (setq web-mode-content-types-alist
	'(("jsx" . "\\.js[x]?\\'")))
  (setq web-mode-attr-indent-offset nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-sql-indent-offset 2)
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq web-mode-comment-style 2)
  (setq web-mode-enable-current-element-highlight t)
  )

;; shell script
(defvar sh-basic-offset 2)
(defvar sh-indentation 2)
(defvar sh-shell-file "/bin/bash")

(use-package csv-mode
  :defer t
  :mode (("\\.csv?\\'" . csv-mode))
  )

(provide 'init)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (yasnippet use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el --- rwanyoike's Emacs configuration

;; Copyright (c) Raymond Wanyoike
;;
;; Author: Raymond Wanyoike <raymond.wanyoike@gmail.com>
;; URL: https://github.com/rwanyoike/emacs.d
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is my personal Emacs configuration.  Nothing more, nothing less.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bootstrap package managers                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "MELPA" url) t))

(package-initialize)

;; update the package metadata if the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

;; bootstrap `use-package'
(unless (package-installed-p 'use-package)
  ;; https://github.com/jwiegley/use-package/
  (package-install 'use-package))

(require 'use-package)

;; treat every package as though it had specified `:ensure t`
(setq use-package-always-ensure t)

;; whether to report about loading and configuration details
(setq use-package-verbose t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global-map                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; align code in a pretty way
; (global-set-key (kbd "C-x \\") 'align-regexp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load packages                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://github.com/emacscollective/auto-compile/
(use-package auto-compile
  :config
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))

;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (exec-path-from-shell-initialize))

;; https://github.com/technomancy/better-defaults/
(use-package better-defaults)

;; https://github.com/magnars/hardcore-mode.el/
(use-package hardcore-mode
  :diminish hardcore-mode
  :init
  (setq too-hardcore-backspace t)
  (setq too-hardcore-return t)
  :config
  (global-hardcore-mode))

;; https://github.com/flycheck/flycheck/
(use-package flycheck
  :config
  (global-flycheck-mode))

;; https://github.com/proofit404/anaconda-mode/
(use-package anaconda-mode
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

;; https://github.com/company-mode/company-mode/
(use-package company
  :diminish company-mode "CMP"
  :config
  (add-to-list 'company-backends 'company-anaconda)
  ; (add-to-list 'company-backends '(company-anaconda :with company-capf))
  (add-to-list 'company-backends 'company-emoji)
  (global-company-mode))

;; https://github.com/proofit404/company-anaconda/
(use-package company-anaconda)

;; https://github.com/dunn/company-emoji/
(use-package company-emoji)

;; https://github.com/emacs-helm/helm/
(use-package helm
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
    ("C-x b" . helm-buffers-list)
    ("C-x C-f" . helm-find-files)
    ("C-x r b" . helm-bookmarks))
  :config
  (helm-mode))

;; https://github.com/Sodel-the-Vociferous/helm-company/
; (use-package helm-company)

;; https://github.com/emacs-helm/helm-descbinds/
(use-package helm-descbinds
  :config
  (helm-descbinds-mode))

;; https://github.com/emacs-helm/helm-describe-modes/
(use-package helm-describe-modes
  :config
  (global-set-key [remap describe-mode] 'helm-describe-modes))

;; https://github.com/emacs-helm/helm-ls-git/
(use-package helm-ls-git
  :bind (("C-x C-d" . helm-browse-project)))

;; https://github.com/magit/magit/
(use-package magit)
; (use-package magit-popup)

;; https://github.com/justbur/emacs-which-key/
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

;; https://github.com/Fanael/highlight-blocks/
(use-package highlight-blocks
  :config
  (add-to-list 'prog-mode-hook 'highlight-blocks-mode))

;; https://github.com/DarthFennec/highlight-indent-guides/
(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character)
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; https://github.com/Fuco1/smartparens/
(use-package smartparens
  :config
  (require 'smartparens-config)
  (add-hook 'prog-mode-hook 'smartparens-mode))

;; https://github.com/Fanael/rainbow-delimiters/
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; https://www.emacswiki.org/emacs/FlySpell/
(use-package flyspell
  :diminish flyspell-mode
  :config
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode))

;; https://www.emacswiki.org/emacs/ElDoc/
(use-package eldoc
  :diminish eldoc-mode
  :config
  (add-hook 'prog-mode-hook 'eldoc-mode))

;; https://www.emacswiki.org/emacs/WhiteSpace/
(use-package whitespace
  :diminish whitespace-mode
  :init
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail))
  :config
  (add-hook 'before-save-hook 'whitespace-cleanup)
  (add-hook 'text-mode-hook 'whitespace-mode)
  (add-hook 'prog-mode-hook 'whitespace-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; themes                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://github.com/greduan/emacs-theme-gruvbox/
(use-package gruvbox-theme)

;; https://github.com/TheBB/spaceline/
(use-package spaceline
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; core packages customization                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq user-full-name "Raymond Wanyoike"
      user-mail-address "raymond.wanyoike@gmail.com")

;; reduce the frequency of garbage collection by making it happen on each 50MB
;; of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable startup screen
(setq inhibit-startup-screen t)

;; mode line settings
(size-indication-mode t)
(line-number-mode t)
(column-number-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Emacs modes typically provide a standard means to change the indentation
;; width -- eg. c-basic-offset: use that to adjust your personal indentation
;; width, while maintaining the style (and meaning) of any files you load.
; (setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; highlight the current line
(global-hl-line-mode +1)

(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'goto-address-prog-mode)

;; automatic line breaking in Text mode and related modes
; (add-hook 'text-mode-hook 'auto-fill-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom-set                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

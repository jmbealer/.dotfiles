;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;
;;(setq doom-font (font-spec :family "Iosevka Term SS09" :size 13 :weight 'semi-light)
(setq doom-font (font-spec :family "Iosevka Term" :size 13 :weight 'semi-light)
      ;; doom-variable-pitch-font (font-spec :family "sans" :size 13))
      doom-variable-pitch-font (font-spec :family "Iosevka" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")
(setq org-roam-directory "~/Documents/org")
(setq org-roam-completion-everywhere t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq whitespace-line-column 80 whitespace-style '(face trailing lines-tail))
(global-whitespace-mode)
(setq-default fill-column 80)
;; (setq auto-fill-mode-hook t)
(add-hook 'text-mode-hook #'auto-fill-mode)

;; (remove-function 'doom--setq-tab-width-for-emacs-lisp-mode-h)

;; (doom--setq-tab-width-for-emacs-lisp-mode-h (2))
;; (setq-default indent-tabs-mode nil)
(setq-default
  delete-by-moving-to-trash t
  tab-width 2
  window-combination-resize t
  x-stretch-cursor nil
  indent-tabs-mode nil
  )
(setq standard-indent 2)
;; (setq tab-width 2)
(setq! lisp-indent-offset 2)
;; (setq-default doom/set-indent-width 2)
(setq-default evil-shift-width 2)
;; (setq doom--setq-tab-width-for-emacs-lisp-mode-h 4)

(setq-default tab-width 2)
;; (setq-hook! 'doom--setq-tab-width-for-emacs-lisp-mode-h tab-width 2)


(setq display-line-numbers-type t)
(global-whitespace-mode t)

(setq doom-modeline-enable-word-count t)

;; (set-face-attribute 'fill-column-indicator nil :foreground "black")
;; (global-display-fill-column-indicator-mode)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! org (setq org-hide-emphasis-markers t))

(use-package! websocket
  :after org-roam)
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
    org-roam-ui-open-on-start t
    tab-width 2))


(setq-default tab-width 2)
;; (setq! 'emacs-lisp-mode tab-width 2)
(setq confirm-kill-emacs nil)
(setq-local tab-width 2)
(after! org-roam (setq-default tab-width 2))
;; (setq-hook! 'elisp--local-variables tab-width = 4)
(setq tab-width 2)

;; (use-package! evil-terminal-cursor-changer
  ;; :hook (tty-setup . evil-terminal-cursor-changer-activate))

;; describe-key
;; s (:n evil-substitute)
(map! :n "s" nil)
(map! :m "s" #'evil-backward-word-begin)
;; S (:n evil-change-whole-line)

;; t (:m evil-find-char-to)
(map! :m "t" #'evil-next-line)
;; T (:m evil-find-char-to backward)

(map! :m "n" #'evil-previous-line)

;; b (:m evil-backward-word-begin)
(map! :m "b" #'evil-forward-word-begin)
;; B (:m evil-backward-WORD-begin)

(map! :m "k" #'evil-ex-search-next)
;; K (:nv +lookup/documentation)
(map! :nv "K" nil)
(map! :m "K" #'evil-ex-search-previous)

;; h = s
(map! :m "h" nil)
(map! :n "h" #'evil-substitute)
(map! :m "H" nil)
(map! :n "H" #'evil-change-whole-line)
;; j = K
(map! :m "j" nil)
(map! :nv "j" #'+lookup/documentation)
;; l = t
(map! :m "l" nil)
(map! :m "l" #'evil-find-char-to)
(map! :m "L" nil)
(map! :m "L" #'evil-find-char-to-backward)

(use-package! org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref)) ; optional: if using Org-ref v2 or v3 citation links

(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   ;; org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   ;; org-noter-always-create-frame nil
   ;; I want to see the whole file
   ;; org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   ;; org-noter-notes-search-path (list org_notes)
   org-noter-notes-search-path '("~/Documents/org")
   )
  )

(setq
  bibtex-completion-library-path '("~/Documents/Books/00-Computing")
  bibtex-completion-pdf-field "file")

;; (use-package! org-drill
  ;; :after org)

;; (use-package! org-fc)

;; (setq cider-allow-jack-in-without-project t)

;; (setq cider-repl-use-content-types t)
;; (setq cljr-inject-dependencies-at-jack-in nil)
;; (setq cider-enrich-classpath nil)

(setq! org-src-fontify-natively t)
(setq! org-confirm-babel-evaluate nil)
;; (setq org-src-window-setup 'current-window)

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Justin Bealer"
      user-mail-address "jmbealer11@gmail.com")

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
;; (setq org-roam-capture-templates
  ;; '(("d" "default" plain "%?"
 ;; :if-new (file+head "test\n" "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
 ;; :unnarrowed t)
  ;; ))

;; (setq! org-roam-capture-templates
  ;; '(("d" "default" plain "%?"
      ;; (file "~/Documents/org/templates/roamDefault.org")
      ;; :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
      ;; :unnarrowed t))
;; )

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

;; evil-window-split
;; +evil/window-split-and-follow
(map! :map doom-leader-map "w s" #'evil-window-left)
(map! :map doom-leader-map "w S" #'+evil/window-move-left)

;; t (:m evil-find-char-to)
(map! :m "t" #'evil-next-line)
;; (map! :map dired-mode-map :nveomrg "t" nil)
;; (map! :mode normal-state :map dired-mode-map "* t" nil)
;; (define-key dired-mode-map (kbd "t") #'evil-next-line)
;; (define-key! dired-mode-map (kbd "t") nil)
;; (unbind-key "t" 'dired-mode-map)
(map! :map dired-mode-map :n "t" #'dired-previous-line)
;; T (:m evil-find-char-to backward)

;; evil-window-top-left
;; tear-off-window
(map! :map doom-leader-map "w t" #'evil-window-down)
(map! :map doom-leader-map "w T" #'+evil/window-move-down)
(map! :map doom-leader-map "b t" #'previous-buffer)

(map! :m "n" #'evil-previous-line)
(map! :map dired-mode-map :n "n" #'dired-next-line)

;; evil-window-new
(map! :map doom-leader-map "w n" #'evil-window-up)
(map! :map doom-leader-map "w N" #'+evil/window-move-up)

;; b (:m evil-backward-word-begin)
(map! :m "b" #'evil-forward-word-begin)
;; B (:m evil-backward-WORD-begin)

;; evil-window-bottom-right
(map! :map doom-leader-map "w b" #'evil-window-right)
(map! :map doom-leader-map "w B" #'+evil/window-move-right)
(map! :map treemacs-mode-map "t" #'treemacs-next-line)
(map! :map treemacs-mode-map "n" #'treemacs-previous-line)
;; treemacs-next-line was j
;; treemacs-previous-line was k
;; treemacs-add-bookmark = was b

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

;; (map! :m org-mode-map
        ;; :n "M-s" #'org-metaleft
        ;; :n "M-t" #'org-metadown
        ;; :n "M-n" #'org-metaup
        ;; :n "M-l" #'org-metaright
  ;; )

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

;; (lsp-stdio-connection '("/usr/bin/env bash" "-c" "clojure-lsp"))
;; (lsp-stdio-connection '("/usr/bin/env bash" "-c" "/usr/local/bin/clojure-lsp"))
;; /usr/bin/env emacs --daemon
;; (use-package lsp-mode
  ;; :commands lsp
  ;; :config
  ;; (dolist (m '(clojure-mode
               ;; clojurec-mode
               ;; clojurescript-mode
               ;; clojurex-mode))
    ;; (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
  ;; :custom
  ;; ((lsp-clojure-server-command '("bash" "-c" "/usr/local/bin/clojure-lsp")) ;; <- here
   ;; (lsp-enable-indentation nil))
  ;; :hook
  ;; (clojure-mode . lsp)
  ;; (clojurec-mode . lsp)
  ;; (clojurescript-mode . lsp))
(setq lsp-clojure-custom-server-command '("bash" "-c" ".local/bin/clojure-lsp"))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(setq! org-indent-mode nil)
;; (add-hook! 'org-mode-hook (electric-indent-local-mode -1))
(electric-indent-mode -1) ; globally
(after! org
  (setq org-startup-indented nil))
;; if you use evil
(map! :after evil-org
      :map evil-org-mode-map
      :i [return] #'+default/newline
      :i "RET" #'+default/newline)

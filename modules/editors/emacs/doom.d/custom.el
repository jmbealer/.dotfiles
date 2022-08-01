(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-clojure-custom-server-command '("bash" "-c" "~/.bin/clojure-lsp") t)
 '(lsp-go-gopls-server-path "~/go/bin/gopls")
 '(org-roam-capture-templates
    '(("d" "default" plain "%?" :target
        (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
#+date: %U
")
        :unnarrowed t)))
 '(org-startup-folded 'content)
 '(package-selected-packages
    '(org-pdftools anki-connect anki-mode company-go company-native-complete auto-complete-clang native-complete bash-completion go-complete go go-guru sqlite org-roam org-roam-ui emacsql-mysql emacsql git-commit irony esqlite emacsql-libsqlite3 sqlite3 pg finalize emacsql-sqlite3))
 '(tab-width 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ((org-mode . ((eval . (org-indent-mode -1)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(org-roam-capture-templates
     '(("d" "default" plain "%?" :target
         (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
#+date: %U
")
         :unnarrowed t)))
  '(package-selected-packages
     '(sqlite org-roam org-roam-ui emacsql-mysql emacsql git-commit irony esqlite emacsql-libsqlite3 sqlite3 pg finalize emacsql-sqlite3))
 '(tab-width 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

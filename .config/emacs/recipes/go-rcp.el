;;; go-rcp.el --- Golang support

;;; Code:
(use-package go-mode
  :ensure t
  :defer t
  :mode "\\.go\\'"
  :hook
  (go-mode . (lambda()
               (add-hook 'before-save-hook #'lsp-format-buffer t t)
               (add-hook 'before-save-hook #'lsp-organize-imports t t)
               (lsp-deferred)
               ))
  :bind
  (:map go-mode-map
        ("RET" . newline-and-indent)
        ("M-RET" . newline)
        )
)

(use-package company-go
  :ensure t
  :defer t
  :config
  (eval-after-load "company"
    '(progn
       (my-change-company-backends 'company-go)
       ))
  (add-to-list 'exec-path (concat default-directory "bin"))
  :custom
  (company-go-insert-arguments nil)
  :after go-mode
)

;; (use-package go-eldoc
;;   :ensure t
;;   :after go-mode
;;   :hook
;;   (go-mode . go-eldoc-setup)
;; )


(provide 'go-rcp)
;;; Commentary:
;; go get -u github.com/alecthomas/gometalinter
;; gometalinter --install
;; go get -u github.com/rogpeppe/godef
;; go get -u github.com/nsf/gocode
;;; go-rcp.el ends here

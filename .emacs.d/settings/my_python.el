(defun my-merge-imenu ()
  (interactive)
  (let ((mode-imenu (imenu-default-create-index-function))
        (custom-imenu (imenu--generic-function imenu-generic-expression)))
    (append mode-imenu custom-imenu)))

(defun my_python_hooks()
    (interactive)
    (setq tab-width 4)
    (setq python-indent 4)
    (setq-default py-shell-name "ipython")
    (setq-default py-which-bufname "IPython")
    (if (string-match-p "rita" (or (buffer-file-name) ""))
        (setq indent-tabs-mode t)
      (setq indent-tabs-mode nil)
    )
    (add-to-list
        'imenu-generic-expression
        '("Sections" "^#### \\[ \\(.*\\) \\]$" 1))
    ;(setq imenu-create-index-function 'my-merge-imenu)
    (setq imenu-create-index-function 'python-imenu-create-index)
)
(add-hook 'python-mode-hook 'my_python_hooks)


(provide 'my_python)


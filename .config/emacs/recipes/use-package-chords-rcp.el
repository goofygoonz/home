;;; use-package-chords-rcp.el --- Add chord support

;;; Code:
(use-package use-package-chords
  :ensure t
  :demand 1
  :custom
  (key-chord-two-keys-delay 0.2)
  (key-chord-one-key-delay  0.1)
  :config
  (key-chord-mode 1)
  (bind-chord "wq" 'delete-other-windows)
)

(provide 'use-package-chords-rcp)
;;; Commentary:
;;
;;; use-package-chords-rcp.el ends here

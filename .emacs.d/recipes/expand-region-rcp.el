(:name expand-region
       :type github
       :pkgname "magnars/expand-region.el"
       :description "Expand region increases the selected region by semantic units. Just keep pressing the key until it selects what you want."
       :website "https://github.com/magnars/expand-region.el#readme"
       :post-init (progn
                    (global-unset-key (kbd "C-c ."))
                    (global-set-key (kbd "C-c .") 'er/expand-region)
))
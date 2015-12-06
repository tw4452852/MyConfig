;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; show paran
(show-paren-mode t)

;; no backup file
(setq make-backup-files nil)

;; make ibuffer default
(defalias 'list-buffers 'ibuffer)

;; make buff er switch command auto suggestions, also for find-file command
(ido-mode 1)
;; make ido display choices vertically
(setq ido-separator "\n") 
;; display any item that contains the chars you typed
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(provide 'init-misc)

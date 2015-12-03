;; global keymap
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)
(global-set-key (kbd "C-w")     'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "M-s")	'isearch-forward-regexp)
(global-set-key (kbd "M-r")	'isearch-backward-regexp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (tango-dark)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; no backup file
(setq make-backup-files nil)

;; elisp mode specification
(eldoc-mode 1)
(define-key emacs-lisp-mode-map
  (kbd "M-.") 'find-function-at-point)

;; make backspace works on linux
(define-key key-translation-map [?\C-h] [?\C-?])

;; hide menu/tool/scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; make ibuffer default
(defalias 'list-buffers 'ibuffer)

;; make buff er switch command auto suggestions, also for find-file command
(ido-mode 1)
;; make ido display choices vertically
(setq ido-separator "\n") 
;; display any item that contains the chars you typed
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

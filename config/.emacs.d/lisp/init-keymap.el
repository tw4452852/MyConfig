(require-package 'key-chord)
(require-package 'evil)
(require 'key-chord)
(require 'evil)

(key-chord-mode 1)

;; make backspace works on linux
(define-key key-translation-map [?\C-h] [?\C-?])

;; global keymap
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)
(global-set-key (kbd "C-w")     'backward-kill-word)
(global-set-key (kbd "M-s")	'isearch-forward-regexp)
(global-set-key (kbd "M-r")	'isearch-backward-regexp)

;; make `jj` as `esc`
(key-chord-define evil-insert-state-map (kbd "jj") 'evil-normal-state)

;; make `;` as `:`
(define-key evil-normal-state-map (kbd ";") 'evil-ex)

(provide 'init-keymap)

(require 'generic-x)
(define-generic-mode
  'pgplan-mode
  '("--")
  '()
  '()
  '("\\.pgplan$" "\\.plan$")
  nil
  "A mode for postgresql query plan"
  )

(font-lock-add-keywords 
 'pgplan-mode
 '(("-> *\\(Hash[^(:]*\\|Result\\)" . 'font-lock-keyword-face)
   ("-> *[^>]* Scan" . 'font-lock-string-face)
   ("-> *\\(Redistribute Motion\\|Gather Motion\\)" . 'font-lock-doc-face)
   ("-> *\\(Broadcast Motion\\|Append \\|Window\\|\\<Aggregate\\|GroupAggregate\\)" . 'font-lock-variable-name-face)
   ("-> *\\(Sort\\|Unique\\|Materialize\\|Nested Loop\\)" . 'font-lock-warning-face)
   ("slice[0-9]*" . font-lock-function-name-face)
   ("cost=[0-9.]*" . font-lock-keyword-face)
   ("Avg *[0-9.]*" . font-lock-keyword-face)
   ("Max *[0-9.]*" . font-lock-function-name-face)
   ("\\([1-9]\\|[0-9]\\+[0-9]\\) spilling" . font-lock-warning-face)
   ))


(add-hook 
 'pgplan-mode-hook
 (lambda () (yafolding-mode)))

(add-hook 
 'pgplan-mode-hook
 (lambda () (hl-line-mode)))

(add-hook
 'pgplan-mode-hook
  (lambda () (setq buffer-read-only t)))

(add-hook
 'pgplan-mode-hook
 (lambda () (setq truncate-lines t)))

(require 'yafolding)

(provide 'pgplan)


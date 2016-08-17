
(require 'sql)

(defun sql-prepare-with-header ()
  (let ((end
	 (save-excursion
	  (goto-char (point-min))
	  (search-forward-regexp "^---* *END *\\(HEADER\\)*[ \\-]*$" (point-max) t)
	  (point))))
    (shell-command-on-region (point-min) end
			     "send-sql.sh reset")
    end
    ))

(defun sql-send-area (start end analyze)
   (let ((header-end (sql-prepare-with-header)))
     (shell-command-on-region 
      (if (> header-end start) header-end start) end
      (cond ((string-equal "normal" analyze) "send-sql.sh")
	    ((and (not (string-equal analyze ""))
		  (eq 0 (string-match analyze "analyze"))) "send-sql.sh analyze")
	    (t "send-sql.sh explain")))))

(defun sql-send-region (start end)
   (interactive "r")
   (sql-send-area start end "normal"))


(defun sql-send-paragraph ()
   (interactive)
   (let ((start (save-excursion
		  (backward-paragraph)
		  (point)))
	 (end (point)))
     (sql-send-region start end)))


(defun sql-send-buffer ()
   (interactive)
   (sql-send-region (point-min) (point-max)))

(defun sql-explain-region (start end &optional analyze)
  (interactive "r\nsExplain(e) or Explain Analyze(a): ")
  (sql-send-area start end analyze))


(define-key sql-mode-map (kbd "C-c M-r")
   'sql-explain-region)


(defun sql-explain-paragraph (&optional analyze)
   (interactive "sExplain(e) or Explain Analyze(a): " )
   (let ((start (save-excursion
		  (backward-paragraph)
		  (point)))
	 (end (point)))
     (sql-explain-region start end analyze)))

(define-key sql-mode-map (kbd "C-c M-c")
   'sql-explain-paragraph)

(provide 'sql-tmux-runner)

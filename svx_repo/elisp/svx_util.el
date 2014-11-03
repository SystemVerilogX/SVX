;; Copyright (c) 2014, Intel Corporation
;; 
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;; 
;;     * Redistributions of source code must retain the above copyright notice,
;;       this list of conditions and the following disclaimer.
;;     * Redistributions in binary form must reproduce the above copyright
;;       notice, this list of conditions and the following disclaimer in the
;;       documentation and/or other materials provided with the distribution.
;;     * Neither the name of Intel Corporation nor the names of its contributors
;;       may be used to endorse or promote products derived from this software
;;       without specific prior written permission.
;; 
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


;; Elisp utility functions for SVX.


;; SVX Font Definitions

;; Pipesignal
(defvar
  svx-font-lock-pipesignal-face
  'svx-font-lock-pipesignal-face
  "Font to use for SVX pipesignal identifiers")
(defface svx-font-lock-pipesignal-face
  '((t (:foreground "purple")))
  "Font lock mode face used for SVX pipesignal identifiers."
  :group 'font-lock-highlighting-faces)

;; Beh Hier
(defvar
  svx-font-lock-beh-hier-face
  'svx-font-lock-beh-hier-face
  "Font to use for SVX behavioral hierarchy identifiers")
(defface svx-font-lock-beh-hier-face
  '((t (:foreground "#20a0c0")))
  "Font lock mode face used for SVX behavioral hierarchy identifiers."
  :group 'font-lock-highlighting-faces)

;; Pipeline
(defvar
  svx-font-lock-pipeline-face
  'svx-font-lock-pipeline-face
  "Font to use for SVX pipeline identifiers")
(defface svx-font-lock-pipeline-face
  '((t (:foreground "orange")))
  "Font lock mode face used for SVX pipeline identifiers."
  :group 'font-lock-highlighting-faces)

;; When
(defvar
  svx-font-lock-when-face
  'svx-font-lock-when-face
  "Font to use for SVX when identifiers")
(defface svx-font-lock-when-face
  '((t (:foreground "#F04000")))
  "Font lock mode face used for SVX when identifiers."
  :group 'font-lock-highlighting-faces)

;; Stage
(defvar
  svx-font-lock-stage-face
  'svx-font-lock-stage-face
  "Font to use for SVX stage identifiers")
(defface svx-font-lock-stage-face
  '((t (:foreground "DarkGreen" :italic t)))
  "Font lock mode face used for SVX stage identifiers."
  :group 'font-lock-highlighting-faces)

;; SV signal
(defvar
  svx-font-lock-sv-signal-face
  'svx-font-lock-sv-signal-face
  "Font to use for SVX SV signal identifiers")
(defface svx-font-lock-sv-signal-face
  '((t (:foreground "gray50")))
  "Font lock mode face used for SVX SV signal identifiers."
  :group 'font-lock-highlighting-faces)

;; Attribute
(defvar
  svx-font-lock-attribute-face
  'svx-font-lock-attribute-face
  "Font to use for SVX attribute identifiers")
(defface svx-font-lock-attribute-face
  '((t (:foreground "#503890" :italic t)))
  "Font lock mode face used for SVX attribute identifiers."
  :group 'font-lock-highlighting-faces)

;; Alignment
(defvar
  svx-font-lock-alignment-face
  'svx-font-lock-alignment-face
  "Font to use for SVX alignment identifiers")
(defface svx-font-lock-alignment-face
  '((t (:foreground "green")))
  "Font lock mode face used for SVX alignment identifiers."
  :group 'font-lock-highlighting-faces)

;; Indentation
(defvar
  svx-font-lock-indentation-face
  'svx-font-lock-indentation-face
  "Font to use for indentation")
(defface svx-font-lock-indentation-face
  '((t (:background "gray95" :foreground "red" :bold t)))
  "Font lock mode face used for indentation."
  :group 'font-lock-highlighting-faces)


;;
;; SVX Electric function helpers
;;


;; SVX prefix char.
(defun svx-is-line-prefix(char)
  "Returns t if integer char is a valid SVX line prefix char."
  (or (= char ?\ )
      (= char ?\!)))

;; SVX match scope.
;; TODO: This just finds the next string of non-whitespace on this line
;; and checks it's prefix.
;; Could be smarter about matching the range, etc.
(defun svx-match-scope()
  "Scan forward for the next non-whitespace sequence and return
it if it appears to be a scope identifier (and range)"
  (re-search-forward "[^ \t\n]+" (verilog-get-end-of-line) t)  ;; Find non-whitespace string.
  (let ((ident (match-string 0)))
    (if (string-match "^[\\>|?@]" ident)
      ident
      nil)))


;; SVX indentation.
(defun svx-indentation()
  "Returns the number of indentation characters in the current line, including the line prefix char (assumed to be an SVX-context line). Return value is negated for blank lines with no non-indentation content (so <= 0 for blank lines)."
  (save-excursion
    (beginning-of-line)
    (let ((pos1 (point))
          (pos2 (point)))
      (if (not (eolp))
        (setq pos2 (+ 1 pos2)))
      (while (= (char-after pos2) ?\ )
        (setq pos2 (+ 1 pos2)))
      (if (progn (goto-char pos2) (eolp))
        (- pos1 pos2)
        (- pos2 pos1)))))


;; SVX blank-line.
(defun svx-blank-line()
  "Return t if the current line is a blank line."
  (<= (svx-indentation) 0))


(defun svx-context-indentation(&optional blank-ind)
  "Returns the number of indentation characters of the scope of the
current line, including the line prefix char (assumed to be an SVX-context
line). Scans upward for non-blank lines, and returns the max indentation
of that line and the blank lines. Returns -1 for beginning-of-file. (Optional
arg for recursive use only.)  point is moved to the beginning of the
non-blank line, or the next blank line if blank indentation is greater.
So higher scope is on lines above."
  (message "here1")
  (let* ((svx-ind (svx-indentation))
         (neg-ind (if blank-ind (min svx-ind blank-ind) svx-ind)))
                  ;; most negative (blank line) indentation so far.
    (if (<= svx-ind 0)
      ;; blank line
      (if (= (forward-line -1) 0)
        ;; line above exists; recurse
        (svx-context-indentation neg-ind)
        ;; no line above
        -1)
      ;; non-blank line.
      (if (> (- neg-ind) svx-ind)
        (progn
  (message "here2")
          (forward-line 1)  ;; So current line will be higher scope.
          (- neg-ind))
        svx-ind))))


;; SVX Indent Line.
(defun svx-indent-line(num-spaces)
  "SVX indent line"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (if (< (point-at-bol) (point-at-eol))  ;; if non-empty line
      (progn
        (goto-char (forward-point 1))
        (if (>= num-spaces 0)
          ;; Indent
          (dotimes (cnt num-spaces)
            (insert-string " "))
          ;; Un-indent
          (dotimes (cnt (- num-spaces))
            (if (= (char-after) ?\ )
              (delete-char 1)
              ()
            )
          )
        )
      )
      ())))


;; SVX Indent/Unindent Region or line if no region selected.
;; BUG: After activating this function, then selecting a new point, the region
;; is still active, but with a new point-1.
(defun svx-indent-region (num-spaces)
  "SVX indent/un-indent region"
  (interactive)
  (save-excursion
    (if mark-active
      (let ((pt1 (region-beginning))
            (pt2 (region-end)))
        (goto-char pt2)
        (forward-line 0)
        (svx-indent-line num-spaces)
        (while (> (point) pt1)
          (next-line -1)
          (svx-indent-line num-spaces)
        ))
      (svx-indent-line num-spaces))))


;; SVX scope.
(defun svx-get-scope-string(&optional at-point)
  "Return a string representing the SVX scope of the current line (with
text properties). If at-point, return scope of indentation of point
based on lines above."
  (save-excursion
    (let ((pt (point)))
      (beginning-of-line)
      (let ((ind (if at-point
                   (- pt (point))  ;; point's indentation
                   (svx-context-indentation))) ;; indentation level of found scope.
            (scope-str "")                   ;; scope string to return.
            line-ind)                        ;; indentation of current line.
        (while (> ind 3)  ;; while inside scope below \SVX scope w/
                          ;;   3 space indentation.
          ;; find next higher scope
          (while (if (= 0 (forward-line -1))
                     ;; forward-line -1 successful.
                     (progn         ;; not higher scope line.
                       (setq line-ind (svx-indentation))
                       (or (<= line-ind 0)          ;; blank line
                           (>= line-ind ind)))      ;; deeper indentation
                     ;; beginning of buffer.
                     (progn
                       (setq line-ind 0)
                       nil)))
          (setq ind line-ind)  ;; capture indentation of new scope.
          (if (svx-is-line-prefix (char-after (point)))
            (progn
              (goto-char (+ (point) 1))
              (setq scope-str
                    (let ((ident (svx-match-scope)))
                      (if ident
                        (concat ident scope-str)
                        ""))))
            ""))  ;; Bad line prefix char.
        scope-str))))


;; SVX in indentation.
(defun svx-in-indentation()
  "Return t if inside indentation."
  (save-excursion
    (while (= (char-before ?\ ))
      (goto-char (- (point) 1)))
    (or (bolp)
        (progn (goto-char (- (point) 1)) (bolp)))))


;;;; SVXpp command.
;;(defun svxpp-command()
;;  "Return the SVX command string."
;;  "java -jar /nfs/site/home/sfhoover/wk/SVX/eclipse_svx_git_repo3/target/svxpp.jar beh_hier.vx")




;;
;;  Electric functions
;;


;; TODO: If we are able to differentiate SVX and SV regions, we should have
;;       space and backspace act on indentation levels.
;;;; SVX backspace.
;;(defun svx-backspace()
;;  "Backspace.  1 indentation level if appropriate."
;;  (interactive)
;;  (if (svx-in-indentation)
;;    (delete-char -1))


;; SVX Indent Region or line if no region selected.
;; BUG: After activating this function, then selecting a new point, the region
;; is still active, but with a new point-1.
(defun electric-svx-indent-region()
  "SVX indent region"
  (interactive)
  (svx-indent-region 3))


;; SVX Unindent Region or line if no region selected.
;; BUG: After activating this function, then selecting a new point, the region
;; is still active, but with a new point-1.
(defun electric-svx-unindent-region()
  "SVX un-indent region"
  (interactive)
  (svx-indent-region -3)
  ;; Display scope when unindenting at end of blank line (terminating scope).
  (if (and (not mark-active) (eolp) (svx-blank-line))
    (electric-svx-scope-message t)
    ())
)


;; SVX Electric tab, to insert 3 spaces.
(defun electric-svx-tab()
  "SVX electric tab function to insert 3 spaces."
  (interactive)
  (if mark-active
    (indent-region (region-beginning) (region-end))  ;; Need SVX-specific indent.
    (insert-string "   ")))


;; SVX Electric <shift>-tab, to delete 3 spaces.
(defun electric-svx-shift-tab()
  "SVX electric <shift>-tab function to delete 3 spaces."
  (interactive)
  (if (= (preceding-char) ?\ )
     (delete-char -1)
     ())
  (if (= (preceding-char) ?\ )
     (delete-char -1)
     ())
  (if (= (preceding-char) ?\ )
     (delete-char -1)
     ()))


;; SVX Electric new-line function to indent next line the same as the current.
(defun electric-svx-terminate-line()
  "SVX electric newline function to indent the new line."
  (interactive)
  (newline)
  (let ((above-pos (save-excursion
                     (next-line -1)
                     (point))))
    ;; Insert line prefix char space (if char is a line prefix char).
    (if (svx-is-line-prefix(char-after above-pos))
      (progn
        (insert ?\ )
        (setq above-pos (+ above-pos 1)))
      ())
    ;; Insert spaces as long as the char above is a space.
    (while (= (char-after above-pos) ?\ )
      (insert ?\ )
      (setq above-pos (+ above-pos 1)))
    ;; Indent if above line is a scope line.
    (if (save-excursion
          (next-line -1)
          (svx-match-scope))
      (insert-string "   "))
))


(defun electric-svx-scope-message(&optional at-point)
  "SVX display current scope as message, as defined by (svx-get-scope-string at-point)"
  (interactive)
  (message (concat "Scope: " (svx-get-scope-string at-point))))


(defun electric-svxpp()
  "Run SVXpp"
  (interactive)
  ;;(compile "java -jar /nfs/site/home/sfhoover/wk/SVX/eclipse_svx_git_repo/target/svxpp.jar beh_hier.vx" t))
  (compile "cat beh_hier.vx" t))



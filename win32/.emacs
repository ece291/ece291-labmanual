(custom-set-variables
 '(load-path (quote ("u:/emacs/emacs-20.7/site-lisp" "U:/emacs/emacs-20.7/lisp" "u:/emacs/emacs-20.7/lisp/textmodes" "u:/emacs/emacs-20.7/lisp/progmodes" "u:/emacs/emacs-20.7/lisp/play" "u:/emacs/emacs-20.7/lisp/mail" "u:/emacs/emacs-20.7/lisp/language" "u:/emacs/emacs-20.7/lisp/international" "u:/emacs/emacs-20.7/lisp/gnus" "u:/emacs/emacs-20.7/lisp/emulation" "u:/emacs/emacs-20.7/lisp/emacs-lisp" "u:/emacs/emacs-20.7/lisp/calendar" "u:/emacs/emacsen/site-lisp" "u:/emacs/emacsen/site-lisp/psgml-1.2.2")))
 '(viper-ex-style-motion nil)
 '(viper-ex-style-editing nil)
 '(viper-auto-indent t)
 '(line-number-mode t)
 '(font-lock-mode t nil (font-lock)))

(custom-set-faces)

; make cygwin paths accessible
;(require 'cygwin32-mount)

; make cygwin symlinks accessible
(defun follow-cygwin-symlink ()
  (save-excursion
    (goto-char 0)
    (if (looking-at "!<symlink>")
        (progn
          (re-search-forward "!<symlink>\\(.*\\)\0")
          (find-alternate-file (match-string 1)))
      )))
(add-hook 'find-file-hooks 'follow-cygwin-symlink)

; use bash as the default shell
(setq shell-file-name "bash")
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)
(setq explicit-shell-args '("--login" "-i"))
(setq shell-command-switch "-ic")
(setq w32-quote-process-args t)
(defun bash ()
  (interactive)
  (let ((binary-process-input t)
        (binary-process-output nil))
    (shell)))

(setq process-coding-system-alist (cons '("bash" . (raw-text-dos . raw-text-unix))
                    process-coding-system-alist))

;; Turn on syntax coloring
(cond ((fboundp 'global-font-lock-mode)
;; Turn on font-lock in all modes that support it
(global-font-lock-mode t)
;; maximum colors
(setq font-lock-maximum-decoration t)))

;; load sgml-mode
(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t )

;; in sgml documents, parse dtd immediately to allow immediate
;; syntax coloring
(setq sgml-auto-activate-dtd t)

;; in sgml documents, don't insert comment listing valid available elements
(setq sgml-insert-missing-element-comment nil)

;; set the default SGML declaration. docbook.dcl should work for most DTDs
(setq sgml-declaration "u:/cygwin/usr/local/lib/sgml/dtd/docbook41/docbook.dcl")

;; here we set the syntax color information for psgml
(setq-default sgml-set-face t)
;;
;; Faces.
;;
(make-face 'sgml-comment-face)
(make-face 'sgml-doctype-face)
(make-face 'sgml-end-tag-face)
(make-face 'sgml-entity-face)
(make-face 'sgml-ignored-face)
(make-face 'sgml-ms-end-face)
(make-face 'sgml-ms-start-face)
(make-face 'sgml-pi-face)
(make-face 'sgml-sgml-face)
(make-face 'sgml-short-ref-face)
(make-face 'sgml-start-tag-face)

(set-face-foreground 'sgml-comment-face "dark turquoise")
(set-face-foreground 'sgml-doctype-face "red")
(set-face-foreground 'sgml-end-tag-face "blue")
(set-face-foreground 'sgml-entity-face "magenta")
(set-face-foreground 'sgml-ignored-face "gray40")
(set-face-background 'sgml-ignored-face "gray60")
(set-face-foreground 'sgml-ms-end-face "green")
(set-face-foreground 'sgml-ms-start-face "yellow")
(set-face-foreground 'sgml-pi-face "lime green")
(set-face-foreground 'sgml-sgml-face "brown")
(set-face-foreground 'sgml-short-ref-face "deep sky blue")
(set-face-foreground 'sgml-start-tag-face "dark green")

(setq-default sgml-markup-faces
 '((comment . sgml-comment-face)
 (doctype . sgml-doctype-face)
 (end-tag . sgml-end-tag-face)
 (entity . sgml-entity-face)
 (ignored . sgml-ignored-face)
 (ms-end . sgml-ms-end-face)
 (ms-start . sgml-ms-start-face)
 (pi . sgml-pi-face)
 (sgml . sgml-sgml-face)
 (short-ref . sgml-short-ref-face)
 (start-tag . sgml-start-tag-face)))

(setq font-lock-auto-fontify t)

;; load xml-mode 
(setq auto-mode-alist
(append (list (cons "\\.xml\\'" 'xml-mode))
auto-mode-alist))
(autoload 'xml-mode "psgml" nil t)
(setq sgml-xml-declaration "u:/cygwin/usr/local/lib/sgml/dtd/html/xml.dcl")

;; define html mode
(or (assoc "\\.html$" auto-mode-alist)
(setq auto-mode-alist (cons '("\\.html$" . sgml-html-mode)
auto-mode-alist)))
(or (assoc "\\.htm$" auto-mode-alist)
(setq auto-mode-alist (cons '("\\.htm$" . sgml-html-mode)
auto-mode-alist)))

(defun sgml-html-mode ()
"This version of html mode is just a wrapper around sgml mode."
(interactive)
(sgml-mode)
(make-local-variable 'sgml-declaration)
(make-local-variable 'sgml-default-doctype-name)
(setq
sgml-default-doctype-name    "html"
sgml-declaration             "u:/cygwin/usr/local/lib/sgml/dtd/html/html.dcl"

sgml-always-quote-attributes t
sgml-indent-step             2
sgml-indent-data             t
sgml-minimize-attributes     nil
sgml-omittag                 t
sgml-shorttag                t
)
)

(setq-default sgml-indent-data t)
(setq
sgml-always-quote-attributes   t
sgml-auto-insert-required-elements t
sgml-auto-activate-dtd         t
sgml-indent-data               t
sgml-indent-step               2
sgml-minimize-attributes       nil
sgml-omittag                   nil
sgml-shorttag                  nil
)

;; Start DTD mode for editing SGML-DTDs
(autoload 'dtd-mode "tdtd" "Major mode for SGML and XML DTDs.")
(autoload 'dtd-etags "tdtd"
"Execute etags on FILESPEC and match on DTD-specific regular expressions."
t)
(autoload 'dtd-grep "tdtd" "Grep for PATTERN in files matching FILESPEC." t)

;; Turn on font lock when in DTD mode
(add-hook 'dtd-mode-hooks
'turn-on-font-lock)

(setq auto-mode-alist
(append
(list
'("\\.dcl$" . dtd-mode)
'("\\.dec$" . dtd-mode)
'("\\.dtd$" . dtd-mode)
'("\\.ele$" . dtd-mode)
'("\\.ent$" . dtd-mode)
'("\\.mod$" . dtd-mode))
auto-mode-alist))

;; the regexp for NTEmacs etags
(setq dtd-etags-regex-option
"--regex=\'/<!\\(ELEMENT\\|ENTITY[ \\t]+%\\|NOTATION\\|ATTLIST\\)[ \\t]+\\([^ \\t]+\\)/\\2/\'")
      ;; we need the NTEmacs etags, not the cygwin etags
      (setq dtd-etags-program "u:/emacs/emacs-20.7/bin/etags.exe")

;; PSGML menus for creating new documents
(setq sgml-custom-dtd
'(
  ( "HTML 2.0"
    "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">")
  ( "HTML 2.0 Strict"
    "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0 Strict//EN\">")
  ( "HTML 2.0 Level 1"
    "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0 Strict Level 1//EN\">")
  ( "HTML 3.2 Final"
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">")
  ( "HTML 4"
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\">")
  ( "HTML 4 Frameset"
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Frameset//EN\">")
  ( "HTML 4 Transitional"
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">")
  ( "DocBook 4.1"
   "<!DOCTYPE Book PUBLIC \"-//OASIS//DTD DocBook V4.1//EN\">")
  )
)

;; ecat support
(setq sgml-ecat-files
  (list
    (expand-file-name "u:/cygwin/usr/local/lib/sgml/dtd/html/ecatalog")
    (expand-file-name "u:/cygwin/usr/local/lib/sgml/dtd/docbook41/ecatalog")
))

;; viper support
(setq viper-mode t)
(require 'viper)


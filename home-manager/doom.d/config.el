;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Load custom environment variables
; (doom-load-envvars-file "~/.config/doom/env")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(load-theme 'doom-tomorrow-night t)
(setq doom-theme 'doom-tomorrow-night)
(setq doom-font (font-spec :family "Hack" :size 10))
(custom-theme-set-faces! 'doom-tomorrow-night
  `(flycheck-posframe-background-face :background ,(doom-darken 'grey 0.4))
  `(flycheck-posframe-error-face   :inherit 'flycheck-posframe-face :foreground red)
  `(hi-lock-faces )
  `(org-level-3 :inherit outline-3 :height 1.2)
  `(org-level-2 :inherit outline-2 :height 1.5)
  `(org-level-1 :inherit outline-1 :height 1.75)
  `(org-document-title  :height 2.0 :underline nil))

(setenv "SSH_AUTH_SOCK" "/run/user/1000/gnupg/S.gpg-agent.ssh")

;; (custom-set-faces! '(window-divider :foreground "#363636"))
(setq auth-sources '("~/.authinfo"))

(setq doom-theme 'doom-tomorrow-night
      projectile-enable-caching t
      projectile-completion-system 'ivy
      projectile-indexing-method 'native
      counsel-projectile-sort-buffers t
      counsel-projectile-sort-projects t
      counsel-projectile-sort-files t
      counsel-projectile-sort-directories t
      ;; This determines the style of line numbers in effect. If set to `nil', line
      ;; numbers are disabled. For relative line numbers, set this to `relative'.
      display-line-numbers-type t
      ;; If you use `org' and don't want your org files in the default location below,
      ;; change `org-directory'. It must be set before org loads!
      org-directory "~/org/"
      ;; Evil windows
      evil-split-window-below t
      evil-vsplit-window-right t
      )

(after! projectile
  (require 'f)
  (defun my-projectile-ignore-project (project-root)
    (or
     (f-descendant-of? project-root (expand-file-name "~/.cargo/git"))
     (f-descendant-of? project-root (expand-file-name "~/.cargo/registry"))
     (f-descendant-of? project-root (expand-file-name "~/.rustup")))
    (setq projectile-ignored-project-function #'my-projectile-ignore-project)))

;; Override rustic's cargo output font colors
(setq rustic-ansi-faces ["black"
                         "OrangeRed3"
                         "green3"
                         "yellow3"
                         "SlateGray1"
                         "magenta3"
                         "cyan3"
                         "white"])
;;; WINDOWS
(map! :leader
      :prefix "w"
      "0" #'delete-window)

(map! :leader
      :prefix "w"
      "1" #'delete-other-windows)

(map! :leader
      :prefix "w"
      "SPC" #'other-window)

;;; SEARCH
(map! :ne "SPC /" #'+default/search-project)


;;; WHITESPACE MODE
(after! whitespace
  (whitespace-global-modes -1))

;;; Terminal
(add-hook! 'vterm-mode-hook
  (add-hook 'doom-switch-window-hook #'evil-insert-state nil 'local))

;;; MAGIT
(map! :leader
      :prefix "g"
      :desc "Magit resolve"
      "e" #'magit-ediff-resolve)

;;; EVIL-MC
(map! :nv "gzs"
      #'evil-mc-skip-and-goto-next-match)
(map! :nv
      "gzS" #'evil-mc-skip-and-goto-prev-match)
(map! :v "C-n" (general-predicate-dispatch nil ; fall back to nearest keymap
                 (featurep! :editor multiple-cursors)
                 #'evil-mc-make-and-goto-next-match))
(map! :n "C-n" (general-predicate-dispatch nil ; fall back to nearest keymap
                 (and (featurep! :editor multiple-cursors)
                      (bound-and-true-p evil-mc-cursor-list))
                 #'evil-mc-make-and-goto-next-match))
(map! :n "C-S-n" #'evil-mc-make-cursor-move-next-line)

;;;;; PYTHON
(add-hook 'before-save-hook #'py-isort-before-save)
(setq-hook! 'python-mode-hook flycheck-checker 'python-mypy)


;;;;; RUST
(setq-hook! 'rustic-mode-hook lsp-rust-rustfmt-path (concat (projectile-project-root) "rustfmt.toml"))
(setq rustic-format-on-save t)

;;; LSP
(set-popup-rule! "^\\*lsp-help*" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 2 :slot 0)
;; (setq rustic-analyzer-command '("~/.cargo/bin/ra-multiplex"))

(after! lsp-mode
  (setq lsp-enable-file-watchers nil
        lsp-completion-enable t
        lsp-enable-imenu t
        lsp-inlay-hint-enable t
        lsp-ui-doc-enable t
        lsp-ui-peek-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-show-diagnostics t
        lsp-headerline-breadcrumb-enable t
        lsp-rust-analyzer-cargo-watch-enable nil
        lsp-log-io t
        lsp-ui-doc-delay 0.7
        lsp-ui-sideline-code-actions-prefix " "
        lsp-ui-peek-fontify 'always)
  )

(defun me/load-session ()
  (when (display-graphic-p)
    (doom/load-session "~/.local/share/doom/autosave")))

(add-hook! 'window-setup-hook #'me/load-session)

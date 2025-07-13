;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
;; - `doom-symbol-font' -- for symbols
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
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; 關閉自動提示
(after! corfu
  (setq corfu-auto nil))

;; ======================
;; GPG & Pinentry 配置
;; ======================
;; 启用 EPA（加密接口）
(require 'epa)
(require 'epg)

;; 设置 pinentry 模式为 loopback（关键！）
(setq epg-pinentry-mode 'loopback)
(setq epa-pinentry-mode 'loopback)

;; 启动 pinentry 守护进程
(use-package pinentry
  :config
  (pinentry-start))

;; 配置 GnuPG 路径（Guix 专用）
(setq epg-gpg-program "/home/chuan/.guix-profile/bin/gpg2")
(setq epg-gpg-home-directory "~/.gnupg")

;; 缓存密码设置
(setq epa-file-cache-passphrase t)
(setq epa-file-passphrase-alist-expiry 3600)  ; 1小时缓存

;; 邮件签名设置
(setq mml-secure-openpgp-encrypt-to-self t)
(setq mml-secure-openpgp-sign-with-sender t)

;; 设置全局签名
(setq git-commit-signoff t)
(setq git-commit-signature t)

;; 提交时自动签名
(add-hook! 'git-commit-setup-hook
  (when (and (boundp 'git-commit-signature)
             git-commit-signature)
    (git-commit-signoff)))

;; ======================
;; 美观的密码提示
;; ======================

(defun chuan/pinentry-prompt (type)
  "自定义密码提示"
  (let ((prompt (pcase type
                  ('decrypt "🔑 解锁 GPG 密钥: ")
                  ('sign "✍️ 签名需要密码: ")
                  ('auth "🔒 认证密码: ")
                  (_ "🔑 输入 GPG 密码: "))))
    (read-passwd prompt)))

(advice-add 'pinentry-read-passphrase :override #'chuan/pinentry-prompt)

;; ====================
;; org相关配置
;; ====================
;;agenda任务文件
(setq org-agenda-files '("~/org/normal_task.org"))

;; ====================
;; dired相关配置
;; ====================
(defun dw/dired-mode-hook ()
  (interactive)
  (dired-hide-details-mode 1)
  (hl-line-mode 1))

(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("b" . dired-up-directory))
  :config
  (setq dired-listing-switches "-alvh --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-dwim-target 'dired-dwim-target-next
        dired-hide-details-hide-symlink-targets nil
        dired-kill-when-opening-new-dired-buffer t
        delete-by-moving-to-trash t)

  (add-hook 'dired-mode-hook #'dw/dired-mode-hook))

;;; ----- Appearance -----

(defun dw/set-terminal-title (title)
  (send-string-to-terminal (format "\e]0;%s\a" title)))

(defun dw/clear-background-color (&optional frame)
  (interactive)
  (or frame (setq frame (selected-frame)))
  "unsets the background color in terminal mode"
  (unless (display-graphic-p frame)
    ;; Set the terminal to a transparent version of the background color
    (send-string-to-terminal
     (format "\033]11;[90]%s\033\\"
         (face-attribute 'default :background)))
    (set-face-background 'default "unspecified-bg" frame)))

;; Clear the background color for transparent terminals
(unless (display-graphic-p)
  (add-hook 'after-make-frame-functions 'dw/clear-background-color)
  (add-hook 'window-setup-hook 'dw/clear-background-color)
  (add-hook 'ef-themes-post-load-hook 'dw/clear-background-color))

(when (display-graphic-p)
  (set-face-attribute 'default nil
                      :font "JetBrains Mono"
                      :weight 'normal
                      :height 140)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil
                      :font "JetBrains Mono"
                      :weight 'normal
                      :height 140)

  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil
                      :font "Iosevka Aile"
                      :height 120
                      :weight 'normal)

  ;; Make frames transparent
  (set-frame-parameter (selected-frame) 'alpha-background 93)
  (add-to-list 'default-frame-alist '(alpha-background . 93))
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

(defun dw/apply-ayu-dark-style ()
  (interactive)
  (setopt modus-themes-italic-constructs t
          modus-themes-bold-constructs t
          modus-themes-common-palette-overrides
          `((bg-main "#0F111B")
            (bg-active bg-main)
            (fg-main "#C3CCDF")
            (fg-active fg-main)
            (fringe unspecified)
            (border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified)
            (fg-mode-line-active "#B3B1AD")
            (bg-mode-line-active "#171B27")
            (fg-mode-line-inactive "#65737E")
            (bg-mode-line-inactive "#1C1F29")
            (bg-tab-bar      "#1C1F29")
            (bg-tab-current  bg-main)
            (bg-tab-other    "#171B27")
            (fg-prompt "#F6C177")
            (bg-prompt unspecified)
            (bg-hover-secondary "#65737E")
            (bg-completion "#2f447f")
            (fg-completion "#ffffff")
            (bg-region "#2B2E36")
            (fg-region "#ffffff")

            ;; Heading colors
            (fg-heading-0 "#81A1C1")
            (fg-heading-1 "#81A1C1")
            (fg-heading-2 "#F6C177")
            (fg-heading-3 "#FFB974")
            (fg-heading-4 "#C792EA")

            (fg-prose-verbatim "#A3BE8C")
            (bg-prose-block-contents "#171B27")
            (fg-prose-block-delimiter "#65737E")
            (bg-prose-block-delimiter "#171B27")

            (accent-1 "#7FDBCA")

            (keyword   "#F6C177")
            (builtin   "#81A1C1")
            (comment   "#65737E")
            (string    "#A3BE8C")
            (fnname    "#7FDBCA")
            (type      "#C792EA")
            (variable  "#FFB974")
            (docstring "#8996A2")
            (constant  "#F07178"))))

(defun dw/apply-palenight-style ()
  (interactive)
  (setopt modus-themes-italic-constructs t
          modus-themes-bold-constructs t
          modus-themes-common-palette-overrides
          `((bg-main "#292D3E")
            (bg-active bg-main)
            (fg-main "#EEFFFF")
            (fg-active fg-main)
            (fringe unspecified)
            (border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified)
            (fg-mode-line-active "#A6Accd")
            (bg-mode-line-active "#232635")
            (fg-mode-line-inactive "#676E95")
            (bg-mode-line-inactive "#282c3d")
            (bg-tab-bar      "#242837")
            (bg-tab-current  bg-main)
            (bg-tab-other    bg-active)
            (fg-prompt "#c792ea")
            (bg-prompt unspecified)
            (bg-hover-secondary "#676E95")
            (bg-completion "#2f447f")
            (fg-completion white)
            (bg-region "#3C435E")
            (fg-region white)

            (fg-heading-0 "#82aaff")
            (fg-heading-1 "#82aaff")
            (fg-heading-2 "#c792ea")
            (fg-heading-3 "#bb80b3")
            (fg-heading-4 "#a1bfff")

            (fg-prose-verbatim "#c3e88d")
            (bg-prose-block-contents "#232635")
            (fg-prose-block-delimiter "#676E95")
            (bg-prose-block-delimiter bg-prose-block-contents)

            (accent-1 "#79a8ff")

            (keyword "#89DDFF")
            (builtin "#82aaff")
            (comment "#676E95")
            (string "#c3e88d")
            (fnname "#82aaff")
            (type "#c792ea")
            (variable "#ffcb6b")
            (docstring "#8d92af")
            (constant "#f78c6c"))))

(use-package modus-themes
  :ensure nil
  :demand t
  :init
  (load-theme 'modus-vivendi-tinted t)
  (dw/apply-ayu-dark-style)
  (add-hook 'modus-themes-after-load-theme-hook #'dw/clear-background-color))

;; Make vertical window separators look nicer in terminal Emacs
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

;; Clean up the mode line
(setq-default mode-line-format
              '("%e" "  "
                (:propertize
                 ("" mode-line-mule-info mode-line-client mode-line-modified mode-line-remote))
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                mode-line-format-right-align
                "  "
                (project-mode-line project-mode-line-format)
                " "
                (vc-mode vc-mode)
                "  "
                mode-line-modes
                mode-line-misc-info
                "  ")
              project-mode-line t
              mode-line-buffer-identification '(" %b")
              mode-line-position-column-line-format '(" %l:%c"))

(use-package emacs-solo-rainbow-delimiters
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun emacs-solo/rainbow-delimiters ()
    "Apply simple rainbow coloring to parentheses, brackets, and braces in the current buffer.
Opening and closing delimiters will have matching colors."
    (interactive)
    (let ((colors '(font-lock-keyword-face
                    font-lock-type-face
                    font-lock-function-name-face
                    font-lock-variable-name-face
                    font-lock-constant-face
                    font-lock-builtin-face
                    font-lock-string-face
                    )))
      (font-lock-add-keywords
       nil
       `((,(rx (or "(" ")" "[" "]" "{" "}"))
          (0 (let* ((char (char-after (match-beginning 0)))
                    (depth (save-excursion
                             ;; Move to the correct position based on opening/closing delimiter
                             (if (member char '(?\) ?\] ?\}))
                                 (progn
                                   (backward-char) ;; Move to the opening delimiter
                                   (car (syntax-ppss)))
                               (car (syntax-ppss)))))
                    (face (nth (mod depth ,(length colors)) ',colors)))
               (list 'face face)))))))
    (font-lock-flush)
    (font-lock-ensure))

  (add-hook 'prog-mode-hook #'emacs-solo/rainbow-delimiters))

;; Move global mode string to the tab-bar and hide tab close buttons
(setq tab-bar-close-button-show nil
      tab-bar-separator " "
      tab-bar-format '(tab-bar-format-menu-bar
                       tab-bar-format-tabs-groups
                       tab-bar-separator
                       tab-bar-format-align-right
                       tab-bar-format-global))

;; Turn on the tab-bar
(tab-bar-mode 1)

;; Customize time display
(setq display-time-load-average nil
      display-time-format "%l:%M %p %b %d W%U"
      world-clock-time-format "%a, %d %b %i:%m %p %z"
      world-clock-list
      '(("Etc/UTC" "UTC")
        ("Europe/Athens" "Athens")
        ("America/Los_Angeles" "Seattle")
        ("America/Denver" "Denver")
        ("America/New_York" "New York")
        ("Pacific/Auckland" "Auckland")
        ("Asia/Shanghai" "Shanghai")
        ("Asia/Kolkata" "Hyderabad")))

(display-time-mode 1)

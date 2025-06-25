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

(define-module (chuanguix home-services emacs)
  #:use-module (chuanguix packages emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix transformations)

  #:export (home-emacs-config-service-type))

(define (home-emacs-config-profile-service config)
  (list
   emacs-doom-themes
   emacs-ef-themes

   emacs-next-pgtk
   emacs-tmr
   emacs-buffer-env
   emacs-beframe

   emacs-bluetooth

   emacs-mpv

   emacs-ement

   emacs-lua-mode
   emacs-fennel-mode

   emacs-emojify

   emacs-mood-line
   emacs-minions

   emacs-alert

   emacs-super-save

   emacs-pinentry
   pinentry-emacs

   emacs-evil-nerd-commenter

   emacs-ws-butler

   emacs-hydra

   emacs-vertico
   emacs-corfu
   emacs-kind-icon
   emacs-orderless
   emacs-consult
   emacs-wgrep
   emacs-marginalia
   emacs-embark

   emacs-avy
   emacs-ace-window

   emacs-default-text-scale

   emacs-password-store
   emacs-auth-source-pass

   emacs-xclip

   emacs-org
   emacs-org-modern
   emacs-org-pomodoro
   emacs-org-make-toc
   emacs-org-roam
   emacs-org-ql
   emacs-htmlize
   emacs-denote
   emacs-logos
   ;;dw-emacs-howm

   emacs-magit
   emacs-magit-todos

   git
   (list git "send-email")

   emacs-git-link
   emacs-git-gutter
   emacs-git-gutter-fringe

   ripgrep ;; For consult-ripgrep

   ;emacs-sly
   ;emacs-sly-asdf

   emacs-js2-mode
   emacs-typescript-mode
   emacs-apheleia

   ;emacs-go-mode

   ;emacs-rust-mode
   ;emacs-zig-mode

   emacs-helpful

   emacs-geiser

   emacs-orgalist
   emacs-markdown-mode

   emacs-web-mode
   emacs-skewer-mode

   emacs-yaml-mode

   emacs-flycheck

   emacs-yasnippet
   emacs-yasnippet-snippets

   emacs-smartparens

   emacs-rainbow-delimiters

   emacs-rainbow-mode

   emacs-posframe
   emacs-keycast

   emacs-obs-websocket-el

   emacs-a
   emacs-request

   ;; TODO: Move to mail profile
   isync
   mu
   emacs-mu4e-alert

   emacs-eat
   emacs-esh-autosuggest
   emacs-xterm-color
   emacs-exec-path-from-shell

   emacs-pcmpl-args

   emacs-eshell-syntax-highlighting

   emacs-vterm

   emacs-tracking

   emacs-telega

   emacs-elfeed

   emacs-guix

   emacs-daemons

   emacs-pulseaudio-control

   emacs-docker
   emacs-dockerfile-mode))

(define home-emacs-config-service-type
  (service-type (name 'home-emacs-config)
                (description "Applies my personal Emacs configuration.")
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-emacs-config-profile-service)))
                (default-value #f)))

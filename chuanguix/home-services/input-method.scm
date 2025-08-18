
(define-module (chuanguix home-services input-method)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (guix gexp))

(define (home-input-method-profile-service config)
  (map specification->package
       (list
        "fcitx5"
        "fcitx5-gtk"
        "fcitx5-gtk4"
        "fcitx5-qt"
        "fcitx5-configtool"
        "fcitx5-rime"
        "librime"
        "fcitx5-chinese-addons"
        "dconf")))

(define (home-input-method-environment-variables config)
  '(("GTK_IM_MODULE" . "fcitx")
    ("QT_IM_MODULE" . "fcitx")
    ("XMODIFIERS" . "@im=fcitx")
    ("SDL_IM_MODULE" . "fcitx")
    ("INPUT_METHOD" . "fcitx")
    ;;("GLFW_IM_MODULE" . "ibus")
    ("GUIX_GTK2_IM_MODULE_FILE" . "/run/current-system/profile/lib/gtk-2.0/2.10.0/immodules-gtk2.cache")
    ("GUIX_GTK3_IM_MODULE_FILE" . "/run/current-system/profile/lib/gtk-3.0/3.0.0/immodules-gtk3.cache")))

;; (define (get-dbus-address)
;;   (let* ((uid (getuid))
;;          (runtime-dir (string-append "/run/user/" (number->string uid)))
;;          (bus-socket (string-append runtime-dir "/bus")))
;;     (if (file-exists? bus-socket)
;;         (string-append "unix:path=" bus-socket)
;;         (getenv "DBUS_SESSION_BUS_ADDRESS"))))

;; (define (home-input-method-shepherd-service config)
;;   (list
;;    (shepherd-service
;;     (documentation "Fcitx5 Input Method Service for Guix")
;;     (provision '(fcitx5))
;;     (requirement '(dbus))
;;     (start #~(make-forkexec-constructor
;;               '("fcitx5" "-d"
;;                 "--disable=wayland")         ; 临时禁用 Wayland 模块调试
;;               #:user (getenv "USER")
;;               #:environment-variables
;;               (list
;;                (string-append "DBUS_SESSION_BUS_ADDRESS=" (get-dbus-address))
;;                "XMODIFIERS=@im=fcitx5"
;;                (string-append "PATH=" (getenv "PATH"))
;;                (string-append "HOME=" (getenv "HOME"))
;;                "G_MESSAGES_DEBUG=all")))     ; 启用 GLib 调试输出
;;     (stop #~(make-kill-destructor))
;;     (respawn? #t))))

(define-public home-input-method-service-type
  (service-type (name 'home-input-method)
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-input-method-profile-service)
                       (service-extension
                        home-environment-variables-service-type
                        home-input-method-environment-variables)
                       ;; (service-extension
                       ;;  home-shepherd-service-type
                       ;;  home-input-method-shepherd-service)
                       ))
                (default-value #f)
                (description "Configures and runs the fcitx5 deamon")))

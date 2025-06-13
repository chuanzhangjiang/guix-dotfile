(define-module (chuanguix home-services desktop)
  #:use-module (chuanguix packages fonts)
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:export (home-desktop-service-type))

(use-package-modules compression curl fonts freedesktop gimp glib gnome gnome-xyz
                     gstreamer kde-frameworks linux music package-management
                     password-utils pdf pulseaudio shellutils ssh syncthing terminals
                     video web-browsers wget wm xdisorg xorg qt)

(define (home-desktop-profile-service config)
  (list sway
        swayidle
        swaylock
        fuzzel
        wl-clipboard
        mako
        foot
        gammastep
        grimshot ;; grimshot --notify copy area
        network-manager-applet

        ;; Compatibility for older Xorg applications
        xorg-server-xwayland
        qtwayland

        ;; Flatpak and XDG utilities
        flatpak
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-utils ;; For xdg-open, etc
        xdg-dbus-proxy
        shared-mime-info
        (list glib "bin")

        ;; Appearance
        matcha-theme
        papirus-icon-theme
        breeze-icons ;; For KDE apps
        gnome-themes-extra
        adwaita-icon-theme

        ;; Fonts
        font-jost
        font-iosevka-ss08
        font-iosevka-aile
        font-microsoft-cascadia
        font-jetbrains-mono
        font-google-noto
        font-google-noto-emoji
        font-liberation
        font-awesome

        ;; Browsers
        ;(specification->package "qtwayland@5")
        qutebrowser
        ;vimb

        ;; Authentication
        password-store

        ;; Audio devices and media playback
        mpv
        mpv-mpris
        youtube-dl
        playerctl
        gstreamer
        gst-plugins-base
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
        alsa-utils
        pavucontrol

        ;; Graphics
        gimp-next

        ;; PDF reader
        zathura
        zathura-pdf-mupdf

        ;; File syncing
        syncthing-gtk
        ;; input mehtod

        ;; fcitx
        (specification->package "fcitx5")
        (specification->package "fcitx5-gtk")
        (specification->package "fcitx5-gtk4")
        (specification->package "fcitx5-qt")
        (specification->package "fcitx5-configtool")
        (specification->package "fcitx5-rime")
        (specification->package "librime")
        (specification->package "fcitx5-chinese-addons")
        (specification->package "dconf")

        ;; General utilities
        curl
        wget
        openssh
        zip
        unzip
        trash-cli))

(define (home-desktop-environment-variables config)
  '(("_JAVA_AWT_WM_NONREPARENTING" . "1")
    ;; fcitx输入法
    ("GTK_IM_MODULE" . "fcitx")
    ("QT_IM_MODULE" . "fcitx")
    ("XMODIFIERS" . "@im=fcitx")
    ("SDL_IM_MODULE" . "fcitx")
    ("INPUT_METHOD" . "fcitx")
    ;;("GLFW_IM_MODULE" . "ibus")
    ("GUIX_GTK2_IM_MODULE_FILE" . "/run/current-system/profile/lib/gtk-2.0/2.10.0/immodules-gtk2.cache")
    ("GUIX_GTK3_IM_MODULE_FILE" . "/run/current-system/profile/lib/gtk-3.0/3.0.0/immodules-gtk3.cache")))

(define home-desktop-service-type
  (service-type (name 'home-desktop)
                (description "My desktop environment service.")
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-desktop-profile-service)
                       (service-extension
                        home-environment-variables-service-type
                        home-desktop-environment-variables)))
                (default-value #f)))

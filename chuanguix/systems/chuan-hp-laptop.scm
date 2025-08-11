
(define-module (chuanguix systems chuan-hp-laptop)
  #:use-module (chuanguix utils)
  #:use-module (chuanguix systems base)
  #:use-module (chuanguix systems common)
  #:use-module (chuanguix home-services pipewire)
  #:use-module (chuanguix home-services ydotool)
  #:use-module (gnu home)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu services)
  #:use-module (gnu system)
  #:use-module (gnu system uuid)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices)
  #:use-module (nongnu packages linux))

(define home
  (home-environment
   (services (cons*
    (service home-pipewire-service-type)
    (service home-ydotool-service-type)
    common-home-services))))

(define system
  (operating-system
   (inherit base-operating-system)
   (host-name "chuan-hp-laptop")

   (swap-devices
    (list (swap-space
           (target "/swapfile"))))

(kernel-arguments
    (cons "vm.swappiness=10" %default-kernel-arguments))

   (mapped-devices (list (mapped-device
                           (source (uuid
                                   "2decf318-7f82-49a1-93f4-703d736e2f0a"))
                           (target "guix_root")
                           (type luks-device-mapping))))

   ;; The list of file systems that get "mounted".  The unique
   ;; file system identifiers there ("UUIDs") can be obtained
   ;; by running 'blkid' in a terminal.
   (file-systems (cons* (file-system
                           (mount-point "/")
                           (device "/dev/mapper/guix_root")
                           (type "ext4")
                           (dependencies mapped-devices))
                       (file-system
                           (mount-point "/boot/efi")
                           (device (uuid "59A3-3D18"
                                       'fat32))
                           (type "vfat")) %base-file-systems))
    ))

;; Return home or system config based on environment variable
(if (getenv "RUNNING_GUIX_HOME") home system)

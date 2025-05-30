(define-module (chuanguix systems chuan-guix)
  #:use-module (chuanguix utils)
  #:use-module (chuanguix systems base)
  #:use-module (chuanguix systems common)
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
   (services common-home-services)))

(define system
  (operating-system
   (inherit base-operating-system)
   (host-name "chuan-guix")

    ;; The list of file systems that get "mounted".  The unique
    ;; file system identifiers there ("UUIDs") can be obtained
    ;; by running 'blkid' in a terminal.
    (file-systems (cons* (file-system
                            (mount-point "/")
                            (device (uuid
                                    "cc218fc0-6a1a-4c4e-a7f4-2718446fd879"
                                    'ext4))
                            (type "ext4"))
                        (file-system
                            (mount-point "/boot/efi")
                            (device (uuid "000E-D1A8"
                                        'fat16))
                            (type "vfat")) %base-file-systems))))
   ;; (mapped-devices
   ;;  (list (mapped-device
   ;;         (source (uuid "eaba53d9-d7e5-4129-82c8-df28bfe6527e"))
   ;;         (target "system-root")
   ;;         (type luks-device-mapping))))

   ;; (file-systems (cons*
   ;;                (file-system
   ;;                 (device (file-system-label "system-root"))
   ;;                 (mount-point "/")
   ;;                 (type "ext4")
   ;;                 (dependencies mapped-devices))
   ;;                (file-system
   ;;                 (device "/dev/nvme0n1p2")
   ;;                 (mount-point "/boot/efi")
   ;;                 (type "vfat"))
   ;;                %base-file-systems))))

;; Return home or system config based on environment variable
(if (getenv "RUNNING_GUIX_HOME") home system)

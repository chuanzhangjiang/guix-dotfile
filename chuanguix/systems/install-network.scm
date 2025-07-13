(define-module (chuanguix systems install)
  #:use-module (gnu system)
  #:use-module (gnu system install)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages linux)
  #:use-module (nongnu packages linux)
  #:export (installation-os-nonfree))

(define installation-os-nonfree
  (operating-system
    (inherit installation-os)
    (kernel linux)
    ;; 只包含网络相关固件（有线和无线）
    (firmware (list linux-firmware-wireless
                    linux-firmware-network))

    ;; 精简内核参数
    (kernel-arguments '("quiet" "net.ifnames=0"))

    ;; 精简软件包列表
    (packages
     (append (list git curl vim)  ; 保留核心工具
             (fold delete          ; 移除不必要的默认包
                   (operating-system-packages installation-os)
                   (list exfat-utils fuse-exfat stow emacs-no-x-toolkit))))))

installation-os-nonfree

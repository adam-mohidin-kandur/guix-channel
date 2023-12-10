(define-module (adammk srvcs)
  #:use-module (gnu services)
  #:use-module ((gnu services base) #:prefix gnu-srvcs:)
  #:use-module ((gnu services desktop) #:prefix gnu-srvcs:)
  #:use-module ((gnu services networking) #:prefix gnu-srvcs:)
  #:use-module ((gnu services avahi) #:prefix gnu-srvcs:)
  #:use-module ((gnu services dbus) #:prefix gnu-srvcs:)
  #:use-module ((gnu packages libusb) #:prefix gnu-pkgs:)
  #:use-module ((gnu packages nfs) #:prefix gnu-pkgs:)
  #:use-module ((gnu packages linux) #:prefix gnu-pkgs:)
  #:use-module ((gnu packages gnome) #:prefix gnu-pkgs:)
  #:use-module ((gnu system setuid) #:prefix gnu-sys:)
  #:use-module (guix gexp)
  #:use-module (adammk sys vars)
  #:export (%desktop-services
            %base-services))

(define %desktop-services
  (modify-services gnu-srvcs:%desktop-services
    (gnu-srvcs:guix-service-type
     config => (gnu-srvcs:guix-configuration
		(inherit config)
		(substitute-urls %substitutes-urls)))))

(define %base-services
  (cons*
   ;; Add udev rules for MTP devices so that non-root users can access
   ;; them.
   (simple-service 'mtp gnu-srvcs:udev-service-type (list gnu-pkgs:libmtp))
   ;; Add udev rules for scanners.
   (service gnu-srvcs:sane-service-type)
   ;; Add polkit rules, so that non-root users in the wheel group can
   ;; perform administrative tasks (similar to "sudo").
   gnu-srvcs:polkit-wheel-service

   ;; Allow desktop users to also mount NTFS and NFS file systems
   ;; without root.
   (simple-service 'mount-setuid-helpers setuid-program-service-type
                   (map (lambda (program)
                          (gnu-sys:setuid-program
                           (program program)))
                        (list (file-append gnu-pkgs:nfs-utils
                                           "/sbin/mount.nfs")
                              (file-append gnu-pkgs:ntfs-3g
                                           "/sbin/mount.ntfs-3g"))))

   ;; The global fontconfig cache directory can sometimes contain
   ;; stale entries, possibly referencing fonts that have been GC'd,
   ;; so mount it read-only.
   gnu-srvcs:fontconfig-file-system-service

   ;; NetworkManager and its applet.
   (service gnu-srvcs:network-manager-service-type)
   (service gnu-srvcs:wpa-supplicant-service-type) ;needed by NetworkManager
   (simple-service 'network-manager-applet
                   profile-service-type
                   (list gnu-pkgs:network-manager-applet))
   (service gnu-srvcs:modem-manager-service-type)
   (service gnu-srvcs:usb-modeswitch-service-type)

   ;; The D-Bus clique.
   (service gnu-srvcs:avahi-service-type)
   (service gnu-srvcs:udisks-service-type)
   (service gnu-srvcs:upower-service-type)
   (service gnu-srvcs:accountsservice-service-type)
   (service gnu-srvcs:cups-pk-helper-service-type)
   (service gnu-srvcs:colord-service-type)
   (service gnu-srvcs:geoclue-service-type)
   (service gnu-srvcs:polkit-service-type)
   (service gnu-srvcs:elogind-service-type)
   (service gnu-srvcs:dbus-root-service-type)

   (service gnu-srvcs:ntp-service-type)

   (service gnu-srvcs:x11-socket-directory-service-type)

   (modify-services gnu-srvcs:%base-services
     (gnu-srvcs:guix-service-type
      config => (gnu-srvcs:guix-configuration
		 (inherit config)
		 (substitute-urls %substitutes-urls))))))

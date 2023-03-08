(define-module (dude srvcs workstation)
  #:use-module (dude pkgs emacs)
  #:use-module (dude srvcs base)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu services xorg)
  #:use-module (gnu services desktop)
  #:use-module (gnu services avahi)
  #:use-module (gnu services dbus)
  #:use-module (gnu services sound)
  #:use-module (gnu packages)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages nfs)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gnome) ;; for network-manager-applet
  #:use-module (gnu system setuid)
  #:use-module (guix gexp)
  #:export (%dude-workstation-packages
            %dude-workstation-services))

(define %dude-workstation-packages
  (append
   %dude-base-packages
   (map (compose list specification->package+output)
        '("emacs-guix"))))

(define %dude-workstation-services
  (append
   %dude-base-services
   (list
    (service gdm-service-type)
    (screen-locker-service xlockmore "xlock")
    (simple-service 'mtp udev-service-type (list libmtp))
    (service sane-service-type)
    polkit-wheel-service
    (simple-service
     'mount-setuid-helpers
     setuid-program-service-type
     (map (lambda (program)
            (setuid-program
             (program program)))
          (list (file-append nfs-utils "/sbin/mount.nfs")
		(file-append ntfs-3g "/sbin/mount.ntfs-3g"))))
    fontconfig-file-system-service
    (service network-manager-service-type)
    (service wpa-supplicant-service-type)
    (simple-service 'network-manager-applet
                    profile-service-type
                    (list network-manager-applet))
    (service modem-manager-service-type)
    (service usb-modeswitch-service-type)

    ;; The D-Bus clique.
    (service avahi-service-type)
    (udisks-service)
    (service upower-service-type)
    (accountsservice-service)
    (service cups-pk-helper-service-type)
    (service colord-service-type)
    (geoclue-service)
    (service polkit-service-type)
    (elogind-service)
    (dbus-service)
    (service ntp-service-type)
    x11-socket-directory-service
    (service pulseaudio-service-type)
    (service alsa-service-type))))

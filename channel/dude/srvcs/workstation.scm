(define-module (dude srvcs workstation)
  #:use-module (dude pkgs emacs)
  #:use-module (dude srvcs base)
  #:use-module (dude sys vars)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu services xorg)
  #:use-module (gnu services desktop)
  #:use-module (gnu services avahi)
  #:use-module (gnu services dbus)
  #:use-module (gnu services sound)
  #:use-module (gnu services sddm)
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
  (cons* (service slim-service-type (slim-configuration
                                     (display ":0")
                                     (vt "vt7")))
         (service slim-service-type (slim-configuration
                                     (display ":1")
                                     (vt "vt8")))
         (modify-services %desktop-services
           (delete gdm-service-type)
           (guix-service-type
	    config => (guix-configuration
		       (inherit config)
		       (substitute-urls %substitutes-urls))))))

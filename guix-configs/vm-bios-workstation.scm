(use-modules (gnu) (gnu system nss)
             (gnu services ssh)
             ((adammk srvcs) #:prefix adammk-srvcs:))

(operating-system
  (host-name "vm-workstation")
  (timezone "Europe/Moscow")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/sda"))))

  (file-systems (cons (file-system
                        (device (file-system-label "my-root"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "user")
                (comment "meh")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  (packages (append
	     %base-packages
	     (map (compose list specification->package+output)
		  '("emacs" "emacs-exwm" "emacs-desktop-environment"
                    "nss-certs"
                    "emacs-stuff"
                    "emacs-magit"
                    "emacs-vterm"
                    "emacs-pdf-tools"
                    "adwaita-icon-theme"
                    "font-google-noto"))))

  (services (append adammk-srvcs:%desktop-services
                    (list
                     (service openssh-service-type))))


  (name-service-switch %mdns-host-lookup-nss))

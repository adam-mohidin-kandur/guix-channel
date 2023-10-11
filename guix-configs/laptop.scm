(use-modules (gnu) (gnu system nss)
             (gnu packages gnome)
             (gnu services desktop)
             (gnu services docker)
             (gnu services ssh)
	     (nongnu packages linux)
             (nongnu system linux-initrd)
             ((adammk srvcs) #:prefix adammk-srvcs:))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware sof-firmware))
  (host-name "grimoire")
  (timezone "Europe/Moscow")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
               (theme (grub-theme
                       (inherit (grub-theme))
                       (image #f)))
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "my-root"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (uuid "5C43-2FCB" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons (user-account
                (name "user")
                (comment "-_-")
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
                    "font-google-noto"
                    "texlive"))))

  (services (append adammk-srvcs:%desktop-services
                    (list
                     (service gnome-desktop-service-type)
                     (service bluetooth-service-type)
                     (service docker-service-type))))

  (name-service-switch %mdns-host-lookup-nss))

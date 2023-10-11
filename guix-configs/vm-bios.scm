(use-modules (gnu)
             (gnu services ssh)
             (gnu services samba)
             ((adammk srvcs) #:prefix adammk-srvcs:))

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Moscow")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "server")
  (users (cons* (user-account
                 (name "user")
                 (comment "User")
                 (group "users")
                 (home-directory "/home/user")
                 (supplementary-groups
		  '("wheel" "netdev" "audio" "video")))
		%base-user-accounts))
  (packages (append
             %base-packages
             (map (compose list specification->package+output)
		  '("nss-certs"))))
  (services (append adammk-srvcs:%base-services
                    (list
                     (service openssh-service-type)
                     (service
                      samba-service-type
                      (samba-configuration
                       (enable-winbindd? #t)
                       (enable-smbd? #t)
                       (enable-nmbd? #t)
                       (config-file
                        (local-file "services/smb.conf")))))))
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (targets '("/dev/sda"))
    (keyboard-layout keyboard-layout)))
  (file-systems (cons (file-system
                        (device (file-system-label "my-root"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems)))

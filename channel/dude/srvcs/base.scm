(define-module (dude srvcs base)
  #:use-module ((dude sys vars) #:prefix dude-vars:)
  #:use-module (gnu system)
  #:use-module (gnu packages)
  #:use-module (gnu services base)
  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services guix)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (guix gexp)
  #:export (%dude-base-packages
            %dude-base-services))

(define %dude-base-packages
  (append
   %base-packages
   (map (compose list specification->package+output)
        '("git" "git:send-email" "xrandr" "openssh"
          "emacs" "emacs-exwm" "emacs-desktop-environment"
          "emacs-async" "nss-certs"))))

(define %dude-base-services
  (modify-services %base-services
    (guix-service-type
     config => (guix-configuration
		(inherit config)
		(substitute-urls '("https://mirror.sjtu.edu.cn/guix/"
				   "https://ci.guix.gnu.org"))))))


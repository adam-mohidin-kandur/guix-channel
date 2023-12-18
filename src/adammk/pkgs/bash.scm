(define-module (adammk pkgs bash)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gawk)
  #:use-module (guix git-download)
  #:use-module (guix git)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages bootloaders)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages disk)
  #:use-module (gnu packages backup)
  #:use-module (guix build-system trivial))

(define-public monitor-checker
  (let ((revision "0")
        (commit "c6baf8bea4a039876547295a1b52954daebc1e50"))
    (package
      (name "monitor-checker")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/adam-mohidin-kandur/utils")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "19fw660nx8vpr408h5fhs8abw5587f0w8x28x42k85mhxirw4wzi"))))
      (build-system trivial-build-system)
      (propagated-inputs
       (list xrandr
             gawk
             grep))
      (arguments
       `(#:modules ((guix build utils))
         #:builder
         (begin
           (use-modules (guix build utils))
           ;; copy source
           (copy-recursively (assoc-ref %build-inputs "source") ".")
           ;; patch source
           (substitute* "MonitorChecker.sh"
             (("xrandr") (string-append (assoc-ref %build-inputs "xrandr")
                                        "/bin/xrandr"))
             (("awk") (string-append (assoc-ref %build-inputs "gawk") "/bin/awk"))
             (("grep") (string-append (assoc-ref %build-inputs "grep") "/bin/grep")))
           ;; install phase
           (install-file "MonitorChecker.sh" (string-append %output "/bin")))))
      (home-page "https://github.com/adam-mohidin-kandur/utils")
      (synopsis "")
      (description "")
      (license license:gpl3+))))

(define-public adammk-backuper
  (let ((revision "0")
        (commit "33598f1e10505f5716f96462190fee036f49c4b8"))
    (package
      (name "adammk-backuper")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/adam-mohidin-kandur/utils")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1vzkjab8ybfnfpn1kx1abf6lkvh0i8d32c29hfsyzji9avf3d3jp"))))
      (build-system trivial-build-system)
      (arguments
       `(#:modules ((guix build utils))
         #:builder
         (begin
           (use-modules (guix build utils))
           ;; copy source
           (copy-recursively (assoc-ref %build-inputs "source") ".")
           ;; install phase
           (install-file "Backuper.sh" (string-append %output "/bin")))))
      (home-page "https://github.com/adam-mohidin-kandur/utils")
      (synopsis "")
      (description "")
      (license license:gpl3+))))

(define-public woeusb
  (let ((revision "0")
        ;; named branch is outdated
        (commit "34b400d99d3c4089f487e1d4f7d71970b2d4429e"))
    (package
      (name "woeusb")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/WoeUSB/WoeUSB")
	       (commit commit)))
	 (file-name (git-file-name name version))
	 (sha256
	  (base32 "05ghja2rpn4kqak9yll398na54dscsfnm3z5f2pi54lan98wzimh"))))
      (build-system trivial-build-system)
      (inputs
       (list ntfs-3g grub ncurses parted coreutils util-linux wimlib))
      (arguments
       `(#:modules ((guix build utils))
         #:builder
         (begin
           (use-modules (guix build utils))
           ;; copy source
           (copy-recursively (assoc-ref %build-inputs "source") ".")
           ;; patch source
           (substitute* "sbin/woeusb"
             (("tput sgr0") (string-append (assoc-ref %build-inputs "ncurses")
                                           "/bin/tput"
                                           " sgr0"))
             (("parted --script")
              (string-append (assoc-ref %build-inputs "parted")
                             "/sbin/parted --script"))
             (("parted \\\\")
              (string-append (assoc-ref %build-inputs "parted")
                             "/sbin/parted \\"))
             (("grub-install") (string-append (assoc-ref %build-inputs "grub")
                                              "/sbin/grub-install"))
             (("command -v mkntfs") (string-append
                                     "command -v "
                                     (assoc-ref %build-inputs "ntfs-3g")
                                     "/sbin/mkntfs"))
             (("command_mkntfs_ref=mkntfs") (string-append
                                             "command_mkntfs_ref="
                                             (assoc-ref %build-inputs "ntfs-3g")
                                             "/sbin/mkntfs"))
             (("readlink \\\\") (string-append
                                 (assoc-ref %build-inputs "coreutils")
                                 "/bin/readlink \\"))
             (("wimlib-imagex") (string-append
                                 (assoc-ref %build-inputs "wimlib")
                                 "/bin/wimlib-imagex"))
             ;; could not find partprobe package
             ;; as i see this command never used in the program
             (("partprobe \\\\") "\\"))
           ;; install phase
           (install-file "sbin/woeusb" (string-append %output "/bin"))
           #t)))
      (home-page "https://github.com/WoeUSB/WoeUSB")
      (synopsis "A Microsoft Windows® USB installation media preparer for GNU+Linux")
      (description "Very usefull package for anyone who wants to make a bootable Windows® USB stick
using free and open source operating system.")
      (license license:gpl3+))))

(define-module (dude pkgs bash)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gawk)
  #:use-module (guix git-download)
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
	       (url "https://github.com/adam-kandur/utils")
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
      (home-page "https://github.com/adam-kandur/utils")
      (synopsis "")
      (description "")
      (license license:gpl3+))))

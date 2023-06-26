(define-module (dude pkgs emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (dude pkgs bash))

(define-public emacs-stuff
  (let ((revision "6")
        (commit "4b948cbabb5a4ebb042eacef6e69673d5f2f1949"))
    (package
      (name "emacs-stuff")
      (version (git-version "0.1" revision commit))
      (source
       (origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/adam-kandur/stuff")
	       (commit commit)))
	 (file-name (git-file-name name version))
	 (sha256
	  (base32 "03v4576y7ms96cppdlfphyf0x98sk4nkph3mfp1ifh662z1zqii3"))))
      (build-system emacs-build-system)
      (arguments
       '(#:include '("\\.el$")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'patch-paths-to-commands
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "stuff/tools.org"
                 (("MonitorChecker.sh")
                  (search-input-file inputs "/bin/MonitorChecker.sh")))))
           (add-after 'patch-paths-to-commands 'load-org-files
             (lambda _
               (invoke
                "emacs" "-Q" "--batch" "--load" "script.el"))))))
      (inputs
       (list monitor-checker))
      (propagated-inputs
       (list emacs-async))
      (home-page "https://github.com/adam-kandur/stuff")
      (synopsis "my emacs package")
      (description "my emacs package")
      (license license:gpl3+))))

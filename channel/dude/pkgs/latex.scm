(define-module (dude pkgs latex)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages tex)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu))

(define-public tex-test
  (let ((revision "0")
        (commit "b89a8fefea4d8e1253c26a344cb2f2a0b0bc24aa"))
    (package
      (name "tex-test")
      (version (git-version "0.1" revision commit))
      (source
       (origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/adam-kandur/utils")
	       (commit commit)))
	 (file-name (git-file-name name version))
	 (sha256
	  (base32 "0rhmgnhviq8glswxbgl48z6f6m3z13y4nivshmwq8g1xc2prrv59"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f
         #:phases (modify-phases %standard-phases
                    (delete 'configure)
                    (add-after 'unpack 'fix-build
                      (lambda* (#:key inputs #:allow-other-keys)
                        (chdir "math/skanavi")))
                    (replace 'install
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let* ((out (assoc-ref outputs "out"))
                               (doc (string-append out "/doc")))
                          (install-file "skanavi.pdf" doc))))
                    )))
      ;; (native-inputs
      ;;  (list texlive))
      (home-page "https://github.com/adam-kandur/utils")
      (synopsis "my emacs package")
      (description "my emacs package")
      (license license:gpl3+))))

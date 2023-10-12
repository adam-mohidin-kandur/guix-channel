(define-module (adammk pkgs c)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu))

(define-public backuper
  (let ((revision "0")
        (commit "7e75274acb7775562586e4b81de52a8cbd9f8778"))
    (package
      (name "backuper")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/adam-mohidin-kandur/utils")
	       (commit commit)
               (recursive? #true)))
	 (file-name (git-file-name name version))
	 (sha256
	  (base32
           "1ncjsiabm43hfxw94jrpdaypy1yffz1bs061ax8rsq407ndv035i"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'chdir
             (lambda _
               (chdir "backuper")
               #t))
           (delete 'configure)
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                 (install-file "backuper" bin)))))))
      (home-page "https://github.com/adam-mohidin-kandur/utils")
      (synopsis "")
      (description "")
      (license license:gpl3+))))

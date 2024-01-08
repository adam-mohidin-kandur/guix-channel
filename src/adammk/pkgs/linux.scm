(define-module (adammk pkgs linux)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix git-download)
  #:use-module (nongnu packages linux)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (gnu packages linux))

(define-public my-linux
  (let ((name "my-linux")
        (version "v6.6"))
    (customize-linux
     #:name name
     #:linux linux
     #:defconfig (local-file "files/my.config")
     #:source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/torvalds/linux.git")
                      (commit version)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1n34v4rq551dffd826cvr67p0l6qwyyjmsq6l98inbn4qqycfi49"))))))

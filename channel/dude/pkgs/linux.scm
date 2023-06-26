(define-module (dude pkgs linux)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (gnu packages linux)
  #:use-module (srfi srfi-1)
  #:use-module (nongnu packages linux))

(define* (corrupt-linux-git kernel-package version hash url #:key (name "dude-linux-git"))
  (package
    (inherit
     (customize-linux
      #:name name
      #:source (origin
                 (method git-fetch)
                 (uri (git-reference
	               (url url)
	               (commit version)))
                 (file-name (git-file-name name version))
	         (sha256
	          (base32 hash)))
      #:defconfig (local-file "linux.cfg")))
    (version version)))

(define-public dude-linux-git
  (corrupt-linux-git linux-libre-6.1 "v6.1-rc1"
                     "0agzh4c7ldg9jqinm9zngzbj8rp24l4bk7slmb7xg1d87m01k8dz"
                     "https://github.com/torvalds/linux"))

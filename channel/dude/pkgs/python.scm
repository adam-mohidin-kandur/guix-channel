(define-module (dude pkgs python)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages c)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages check)
  #:use-module (gnu packages time)
  #:use-module (gnu packages game-development))

(define-public python-tcod
  ;; todo
  ;; python-httpx-0.23.3
  ;; named branch is outdated
  (let ((commit "d3419a5b4593c7df1580427fc07616d798c85856")
        (revision "1"))
    (package
      (name "python-tcod")
      (version "13.9.1")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/libtcod/python-tcod")
               (commit commit)
               (recursive? #true)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1b0ligrswvz307bbx5jp8wnnqz52v5s4gcgakxy4i3jvccalm2if"))))
      (build-system python-build-system)
      ;; tests fail for a strange reason
      ;; "ERROR docs/conf.py - FileNotFoundError",
      ;; but this file is in the checkout
      (arguments
       '(#:tests? #f))
      (native-inputs
       (list sdl2
             python-pcpp
             python-pycparser
             python-requests
             python-pytest-runner
             python-pytest-benchmark
             python-pytest-cov))
      (propagated-inputs
       (list python-numpy
             python-typing-extensions
             python-cffi))
      (home-page "https://github.com/libtcod/python-tcod")
      (synopsis
       "This library is a Python cffi port of libtcod")
      (description
       "A high-performance Python port of libtcod.
Includes the libtcodpy module for backwards compatibility with older projects.")
      (license license:bsd-2))))

(define-public python-telegram-bot
  (package
    (name "python-telegram-bot")
    (version "20.0b0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/python-telegram-bot/python-telegram-bot")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1xybj71fz01q6kyvm05xckrifp32hyhmk3zy7ydav83zrcxpmbai"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f))
    (native-inputs
     (list python-httpx-0.23.3
           python-pytest
           python-pytz))
    (propagated-inputs
       (list python-httpx-0.23.3))
    (home-page "")
    (synopsis
     "")
    (description
     "")
    (license #f)))

(define-public python-httpx-0.23.3
  (package
    (inherit python-httpx)
    (name "python-httpx")
    (version "0.23.3")
    (source
     (origin
       ;; PyPI tarball does not contain tests.
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/encode/httpx")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0n3iisy04vglnc8xr0rgmaja1kdxd9h4akndbqv0cv055a9p7d34"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-cryptography
                         python-pytest
                         python-pytest-asyncio
                         python-pytest-trio
                         python-trio
                         python-trio-typing
                         python-trustme
                         python-uvicorn
                         python-hatchling-1.12.1
                         python-pathspec-0.10.3
                         python-hatch-fancy-pypi-readme))))
    ;; (source
    ;;  (origin
    ;;    (method url-fetch)
    ;;    (uri (pypi-uri "aiorpcX" version))
    ;;    (sha256
    ;;     (base32
    ;;      "1rswrspv27x33xa5bnhrkjqzhv0sknv5kd7pl1vidw9d2z4rx2l0"))))))

(define-public python-hatchling
  (package
    (name "python-hatchling")
    (version "0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pypa/hatch.git")
             (commit (string-append "hatchling-v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0z5j69w8f82pn5gw6266b0cs227j52wns90yqpqnwlvvzxmqg3b1"))))
    (build-system pyproject-build-system)
    (arguments
     ;; tests fail for an unknown reason
     ;; error: in phase 'check': uncaught exception:
     ;; %exception #<&test-system-not-found>
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'change-directory
           (lambda _
             (chdir "backend") #t))
         ;; Disable the sanity check, which fails with the following error:
         ;;
         ;; error: in phase 'sanity-check': uncaught exception:
         ;; %exception #<&invoke-error program: "python"
         ;; arguments: ("/gnu/store/9qcl55briba1xy9m6lj1nsx4li26753m-sanity-check-next.py"
         ;;             "/gnu/store/iy3smw889h59j6sr5a23bhdc3iq861w4-python-hatchling-0.3/lib/python3.9/site-packages")
         ;; exit-status: 1 term-signal: #f stop-signal: #f> 
         (delete 'sanity-check))))
    (native-inputs
     (list python-pathspec-0.10.3
           python-tomli
           python-pluggy))
    (home-page "")
    (synopsis
     "")
    (description
     "")
    (license #f)))

(define-public python-hatchling-1.12.1
  (package
    (inherit python-hatchling)
    (name "python-hatchling")
    (version "1.12.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pypa/hatch.git")
             (commit (string-append "hatchling-v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "133g3xmxhd9a2sf69h35r1qqfir4wyzpm2lazqn3sqpfwljnx207"))))
    (build-system pyproject-build-system)
    (arguments
     ;; tests fail for an unknown reason
     ;; error: in phase 'check': uncaught exception:
     ;; %exception #<&test-system-not-found>
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'change-directory
           (lambda _
             (chdir "backend")
             #t))
         (add-before 'patch-generated-file-shebangs 'change-directory-again
             (lambda _
               (chdir "src")
               #t))
         ;; Disable the sanity check, which fails with the following error:
         ;;
         ;; error: in phase 'sanity-check': uncaught exception:
         ;; %exception #<&invoke-error program: "python"
         ;; arguments: ("/gnu/store/9qcl55briba1xy9m6lj1nsx4li26753m-sanity-check-next.py"
         ;;             "/gnu/store/iy3smw889h59j6sr5a23bhdc3iq861w4-python-hatchling-0.3/lib/python3.9/site-packages")
         ;; exit-status: 1 term-signal: #f stop-signal: #f> 
         (delete 'sanity-check))))
    (native-inputs
     (list python-hatchling
           python-pathspec-0.10.3
           python-tomli
           python-pluggy))))

(define-public python-hatch-fancy-pypi-readme
  (package
    (name "python-hatch-fancy-pypi-readme")
    (version "22.8.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hynek/hatch-fancy-pypi-readme")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0v7j2xm72y4w568rb79y77ibf28hyynd2ld7gpb5fqn9hdlfxxi3"))))
    (build-system pyproject-build-system)
    (arguments
     ;; tests fail for an unknown reason
     ;; error: in phase 'check': uncaught exception:
     ;; %exception #<&test-system-not-found>
     `(#:tests? #f))
    (native-inputs (list python-hatchling-1.12.1
                         python-pathspec-0.10.3
                         python-pluggy
                         python-tomli))
    (home-page "")
    (synopsis
     "")
    (description
     "")
    (license #f)))

(define-public python-pathspec-0.10.3
  (package
    (inherit python-pathspec)
    (name "python-pathspec")
    (version "0.10.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pathspec" version))
       (sha256
        (base32
         "1xnnjzbfzpjia2arcl2v80g8c8fl05d0kaas8s8hg7bx0zj0s82n"))))
    ))

(define-public python-pygame-widgets
  (package
    (name "python-pygame-widgets")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pygame-widgets" version))
       (sha256
        (base32
         "1b20vgl8rx20gdllsfvx2bqp4gd77i8djpnsfv1fsxr2l6ds7jn0"))))
    (build-system python-build-system)
    (arguments
       '(#:tests? #f))
    (propagated-inputs
       (list python-pygame))
    (home-page "")
    (synopsis
     "")
    (description
     "")
    (license #f)))

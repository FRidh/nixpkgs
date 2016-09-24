{ stdenv, fetchurl
, bzip2
, gdbm
, libX11, xproto
, lzma
, ncurses
, openssl
, readline
, sqlite
, tcl, tk
, zlib
, callPackage
, self
, python35Packages

, CF, configd
}:

assert readline != null -> ncurses != null;

with stdenv.lib;

let

  common = import ../common.nix {
    version = "3.5.2";
    pythonVersion = "3.5";
    pythonPackages = python35Packages;
  };
  inherit (common);
in stdenv.mkDerivation (common // {

  buildInputs = filter (p: p != null) [
    zlib
    bzip2
    lzma
    gdbm
    sqlite
    readline
    ncurses
    openssl
    tcl
    tk
    libX11
    xproto
  ] ++ optionals stdenv.isDarwin [ CF configd ];

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${fullVersion}.tar.xz";
    sha256 = "0h6a5fr7ram2s483lh0pnmc4ncijb8llnpfdxdcl5dxr01hza400";
  };

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lgcc_s";

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
    substituteInPlace configure --replace '-Wl,-stack_size,1000000' ' '
  '';

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''
       export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"
       export MACOSX_DEPLOYMENT_TARGET=10.6
     ''}

    configureFlagsArray=( --enable-shared --with-threads
                          CPPFLAGS="${concatStringsSep " " (map (p: "-I${getDev p}/include") buildInputs)}"
                          LDFLAGS="${concatStringsSep " " (map (p: "-L${getLib p}/lib") buildInputs)}"
                          LIBS="${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}"
                        )
  '';

  setupHook = ./setup-hook.sh;

  postInstall = ''
    # needed for some packages, especially packages that backport functionality
    # to 2.x from 3.x
    for item in $out/lib/python${pythonVersion}/test/*; do
      if [[ "$item" != */test_support.py* ]]; then
        rm -rf "$item"
      else
        echo $item
      fi
    done
    touch $out/lib/python${pythonVersion}/test/__init__.py

    ln -s "$out/include/python${pythonVersion}m" "$out/include/python${pythonVersion}"
    paxmark E $out/bin/python${pythonVersion}
  '';

  postFixup = ''
    # Get rid of retained dependencies on -dev packages, and remove
    # some $TMPDIR references to improve binary reproducibility.
    for i in $out/lib//python${pythonVersion}/_sysconfigdata.py $out/lib/python${pythonVersion}/config-${pythonVersion}m/Makefile; do
      sed -i $i -e "s|-I/nix/store/[^ ']*||g" -e "s|-L/nix/store/[^ ']*||g" -e "s|$TMPDIR|/no-such-path|g"
    done

    # FIXME: should regenerate this.
    rm $out/lib/python${pythonVersion}/__pycache__/_sysconfigdata.cpython*
  '';

  passthru = rec {
    zlibSupport = zlib != null;
    sqliteSupport = sqlite != null;
    dbSupport = false;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null) && (libX11 != null) && (xproto != null);
    libPrefix = "python${pythonVersion}";
    executable = "python${pythonVersion}m";
    buildEnv = callPackage ../../wrapper.nix { python = self; };
    withPackages = import ../../with-packages.nix { inherit buildEnv; pythonPackages = python35Packages; };
    isPy3 = true;
    isPy35 = true;
    is_py3k = true;  # deprecated
    sitePackages = "lib/${libPrefix}/site-packages";
    interpreter = "${self}/bin/${executable}";
  };
})

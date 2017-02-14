{ stdenv, fetchurl, slang, popt, gpm, python }:

stdenv.mkDerivation rec {
  version = "0.52.19";
  name = "libnewt-" + version;

  src = fetchurl {
    url = "https://releases.pagure.org/newt/newt-${version}.tar.gz";
    sha256 = "101fzx5n711wj01rpkcixyfc1iklny8r9fdsgimaz5hrq9bdph08";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/po/Makefile \
      --replace "/usr/bin/" ""
    substituteInPlace $sourceRoot/configure \
      --replace "/usr/include/python" "${python}/include/python"
    substituteInPlace $sourceRoot/configure.ac \
      --replace "/usr/include/python" "${python}/include/python"
  '';

  buildInputs = [ slang popt gpm python ];

  configureFlags= [ "--with-gpm-support" ];

  meta = {
    homepage = https://pagure.io/newt;
    description = "Programming library for color text mode, widget based user interfaces.";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ryantm ];
  };
}

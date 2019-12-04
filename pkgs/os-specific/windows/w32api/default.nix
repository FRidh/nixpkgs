{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "w32api";
  version = "5.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/w32api/${pname}-${version}/${pname}-${version}-mingw32-src.tar.lzma";
    sha256 = "09rhnl6zikmdyb960im55jck0rdy5z9nlg3akx68ixn7khf3j8wa";
  };

  meta = {
    platforms = lib.platforms.windows;
  };

  dontStrip = true;
}

{ stdenv
, mkDerivation
, version
, src
, limesuite
}:

mkDerivation {
  pname = "gr-limesdr";
  inherit version src;

  buildInputs = [
    limesuite
  ];

  meta = with stdenv.lib; {
    description = "Gnuradio source and sink blocks for LimeSDR";
    homepage = "https://wiki.myriadrf.org/Gr-limesdr_Plugin_for_GNURadio";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}

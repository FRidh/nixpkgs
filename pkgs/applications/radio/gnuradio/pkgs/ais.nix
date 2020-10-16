{ stdenv
, mkDerivation
, src
, version
, gnuradioPackages
}:

mkDerivation {
  pname = "gr-ais";
  inherit version src;

  buildInputs = [
    gnuradioPackages.osmosdr
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for ais";
    homepage = "https://github.com/bistromath/gr-ais";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}

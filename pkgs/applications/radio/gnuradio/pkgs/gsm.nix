{ stdenv
, mkDerivation
, version
, src
, libosmocore
, gnuradioPackages
}:

mkDerivation {
  pname = "gr-gsm";
  inherit version src;

  buildInputs = [
    libosmocore gnuradioPackages.osmosdr
  ];

  meta = with stdenv.lib; {
    description = "Gnuradio block for gsm";
    homepage = "https://github.com/ptrkrysik/gr-gsm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}

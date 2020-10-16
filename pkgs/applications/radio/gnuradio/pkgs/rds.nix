{ stdenv
, mkDerivation
, version
, src
}:

mkDerivation {
  pname = "gr-rds";
  inherit version src;

  meta = with stdenv.lib; {
    description = "Gnuradio block for radio data system";
    homepage = "https://github.com/bastibl/gr-rds";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}

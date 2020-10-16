{ stdenv
, mkDerivation
, src
, version
, gnuradio
, airspy
, hackrf
, libbladeRF
, rtl-sdr
, soapysdr-with-plugins
}:

mkDerivation rec {
  pname = "gr-osmosdr";
  inherit version src;

  buildInputs = [
    airspy
    hackrf
    libbladeRF
    rtl-sdr
    soapysdr-with-plugins
  ];
  nativeBuildInputs = stdenv.lib.optionals
    (
      (gnuradio.hasFeature "python-support" gnuradio.features) &&
      (gnuradio.versionAttr.major == "3.7")
    )
    [ gnuradio.python.pkgs.cheetah ]
  ;

  meta = with stdenv.lib; {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
  };
}

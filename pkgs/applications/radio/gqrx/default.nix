{ stdenv
, fetchFromGitHub
# Because we use gnuradioMinimal.callPackage to build this package, qt is not
# added automatically to the buildInputs, so we use whatever qt5 is defined in
# all-packages.nix
, qt5
, gnuradioPackages
, mkDerivation
# drivers (optional):
, rtl-sdr, hackrf
}:

mkDerivation rec {
  pname = "gqrx";
  version = "2.14.3";

  src = fetchFromGitHub {
    owner = "csete";
    repo = "gqrx";
    rev = "v${version}";
    sha256 = "10pmd2jqmw77gybjfzrch6qi8jil1g6nsjzabbd6gnbsq7320axj";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [
    qt5.qtbase qt5.qtsvg gnuradioPackages.osmosdr rtl-sdr hackrf
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD $src/gqrx.desktop -t "$out/share/applications/"
    install -vD $src/resources/icons/gqrx.svg -t "$out/share/pixmaps/"
  '';

  meta = with stdenv.lib; {
    description = "Software defined radio (SDR) receiver";
    longDescription = ''
      Gqrx is a software defined radio receiver powered by GNU Radio and the Qt
      GUI toolkit. It can process I/Q data from many types of input devices,
      including Funcube Dongle Pro/Pro+, rtl-sdr, HackRF, and Universal
      Software Radio Peripheral (USRP) devices.
    '';
    homepage = "https://gqrx.dk/";
    # Some of the code comes from the Cutesdr project, with a BSD license, but
    # it's currently unknown which version of the BSD license that is.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;  # should work on Darwin / macOS too
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}

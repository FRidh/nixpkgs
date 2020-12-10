{ stdenv
, mkDerivation
, fetchFromGitHub
, libpulseaudio
, libconfig
# Needs a gnuradio built with qt gui support
, gnuradio
, gnuradioPackages
, gsm
, libopus
, libjpeg
, libsndfile
, libftdi
, protobuf
, speex
, speexdsp
}:

mkDerivation rec {
  pname = "qradiolink";
  version = "0.8.5-rc5";

  src = fetchFromGitHub {
    owner = "qradiolink";
    repo = "qradiolink";
    rev = version;
    sha256 = "gChAN5Vs57oSZfUdKGKWEmhRueY1ftVKWVpuFqUOKC0=";
  };

  preBuild = ''
    cd src/ext
    protoc --cpp_out=. Mumble.proto
    protoc --cpp_out=. QRadioLink.proto
    cd ../..
    qmake
  '';

  installPhase = ''
    install -D qradiolink $out/bin/qradiolink
    install -Dm644 qradiolink.desktop $out/share/applications/qradiolinl.desktop
  '';

  buildInputs = [
    libpulseaudio
    libconfig
    gsm
    gnuradioPackages.osmosdr
    libopus
    libjpeg
    speex
    speexdsp
    gnuradio.qt.qtbase
    gnuradio.qt.qtmultimedia
    libftdi
    libsndfile
    gnuradio.qwt
  ];
  nativeBuildInputs = [
    protobuf
    gnuradio.qt.qmake
    gnuradio.qt.wrapQtAppsHook
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "SDR transceiver application for analog and digital modes";
    homepage = "http://qradiolink.org/";
    license = licenses.agpl3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

{ lib
, mkDerivation
, fetchFromGitHub
# Because we use gnuradioMinimal.callPackage to build this package, qt is not
# added automatically to the buildInputs, so we use whatever qt5 is defined in
# all-packages.nix
, qt5
, liquid-dsp
}:

mkDerivation rec {
  pname = "inspectrum";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "v${version}";
    sha256 = "1x6nyn429pk0f7lqzskrgsbq09mq5787xd4piic95add6n1cc355";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [
    liquid-dsp
    qt5.qtbase
  ];

  meta = with lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = "https://github.com/miek/inspectrum";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}

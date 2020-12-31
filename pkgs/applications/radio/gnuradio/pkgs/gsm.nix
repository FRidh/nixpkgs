{ stdenv
, mkDerivation
, fetchFromGitHub
, libosmocore
, osmosdr
}:

mkDerivation {
  pname = "gr-gsm";
  version = "2016-08-25";
  src = fetchFromGitHub {
    owner = "ptrkrysik";
    repo = "gr-gsm";
    rev = "3ca05e6914ef29eb536da5dbec323701fbc2050d";
    sha256 = "13nnq927kpf91iqccr8db9ripy5czjl5jiyivizn6bia0bam2pvx";
  };
  disabled = ["3.8"];

  buildInputs = [
    libosmocore
    osmosdr
  ];

  meta = with stdenv.lib; {
    description = "Gnuradio block for gsm";
    homepage = "https://github.com/ptrkrysik/gr-gsm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}

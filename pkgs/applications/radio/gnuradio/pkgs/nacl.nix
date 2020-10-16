{ stdenv
, mkDerivation
, version
, src
, libsodium
}:

mkDerivation {
  pname = "gr-nacl";
  inherit version src;
  buildInputs = [
    libsodium
  ];

  meta = with stdenv.lib; {
    description = "Gnuradio block for encryption";
    homepage = "https://github.com/stwunsch/gr-nacl";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}

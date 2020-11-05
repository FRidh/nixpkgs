{
  mkDerivation, lib, extra-cmake-modules, qtbase
, qtdeclarative, kconfig, kcoreaddons, ki18n, kio, kirigami2
, fetchpatch
}:

mkDerivation {
  name = "purpose";
  meta = { maintainers = [ lib.maintainers.bkchr ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase qtdeclarative kconfig kcoreaddons 
    ki18n kio kirigami2
  ];

  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/purpose/-/commit/b3842a0941858792e997bb35b679a3fdf3ef54ca.patch";
      sha256 = "crhHcZ7gS51ssznGy7z/JPMBmr3UkVlViDS7nH2+eZE=";
    })
  ];
}

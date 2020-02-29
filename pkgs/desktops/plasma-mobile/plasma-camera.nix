{ mkDerivation

, extra-cmake-modules 
, kdoctools

, kcoreaddons
, kirigami2
, qtquickcontrols2

}:

mkDerivation {
  name = "plasma-camera";

  nativeBuildInputs = [ 
    extra-cmake-modules 
    kdoctools 
  ];

  buildInputs = [
    kcoreaddons
    kirigami2
    qtquickcontrols2
  ];

}
{ mkDerivation

, extra-cmake-modules
, kdoctools

, kdeclarative
, kio
, kpeople
, kservice
, plasma-framework
, telepathy
, telepathy_qt

}:

mkDerivation {
  name = "plasma-phone-components";

  nativeBuildInputs = [ 
    extra-cmake-modules 
    kdoctools 
  ];

  buildInputs = [
    kdeclarative
    kio
    kpeople
    kservice
    plasma-framework
    telepathy
  ];

}
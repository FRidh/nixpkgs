{ mkDerivation

, extra-cmake-modules
, kdoctools

, kauth
, kdeclarative
, kdelibs4support
, kio
, plasma-framework
, solid
}:

mkDerivation {
  name = "plasma-settings";

  nativeBuildInputs = [ 
    extra-cmake-modules 
    kdoctools 
  ];

  buildInputs = [
    kauth
    kdeclarative
    kdelibs4support
    kio
    plasma-framework
    solid
  ];

}
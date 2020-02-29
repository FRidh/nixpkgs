{ mkDerivation 

, extra-cmake-modules 
, kdoctools 

, pam
}:

mkDerivation {
  name = "simplelogin";

  nativeBuildInputs = [ 
    extra-cmake-modules 
    kdoctools 
  ];

  buildInputs = [
    pam
  ];

  HOME="${placeholder "out"}";

  cmakeFlags = [
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
  ];

}
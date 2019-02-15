{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "whichcraft";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fecddd531f237ffc5db8b215409afb18fa30300699064cca4817521b4fc81815";
  };

  buildInputs = [  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = https://github.com/pydanny/whichcraft;
    description = "Cross-platform cross-python shutil.which functionality";
    license = licenses.bsd3;
  };
}

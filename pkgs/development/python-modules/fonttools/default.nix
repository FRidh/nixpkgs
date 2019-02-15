{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner

}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.37.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c898a455a39afbe6707bc17a0e4f720ebe2087fec67683e7c86a13183078204d";
    extension = "zip";
  };

  buildInputs = [
    numpy
  ];

  checkInputs = [
    pytest
    pytestrunner
    
  ];

  preCheck = ''
  '';

  meta = {
    homepage = https://github.com/fonttools/fonttools;
    description = "A library to manipulate font files from Python";
  };
}

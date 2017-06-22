{ lib
, buildPythonPackage
, fetchPypi

}:


buildPythonPackage rec {
  pname = "qtpy";
  version = "1.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5803ce31f50b24295e8e600b76cc91d7f2a3140a5a0d526d40226f9ec5e9097d";
  };

  meta = {
    description = "Provides an abstraction layer on top of the various Qt bindings";
    homepage = https://github.com/spyder-ide/qtpy;
    license = with lib.licenses; [ mit ];
  };

}
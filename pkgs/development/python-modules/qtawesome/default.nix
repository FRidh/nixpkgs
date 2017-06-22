{ lib
, buildPythonPackage
, fetchPypi
, qtpy
, six
}:

buildPythonPackage rec {
  pname = "QTAwesome";
  version = "0.4.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50f9c1d9ce34e57f5b13ef76d5c87e06de9804b8dfe1c34c4ba73197200f878a";
  };

  propagatedBuildInputs = [ qtpy six ];

  meta = {
    description = "FontAwesome icons in PyQt and PySide applications";
    homepage = "https://github.com/spyder-ide/qtawesome";
    license = with lib.licenses; [ mit ];
  };
}
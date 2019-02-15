{ stdenv, buildPythonPackage, fetchPypi, pytest, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "571702b5bd167911fe9036e5039ba67f820d6502832285cde8c881ab2b2149fd";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "parso==0.1.0" "parso"
  '';

  checkInputs = [ pytest  tox pytestcov ];

  propagatedBuildInputs = [ parso ];

  checkPhase = ''
  '';

  # tox required for tests: https://github.com/davidhalter/jedi/issues/808
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/davidhalter/jedi;
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ garbas ];
  };
}

{stdenv, buildPythonPackage, fetchFromGitHub, numpy, pybind11}:

buildPythonPackage rec {
  pname = "fasttext";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = "v${version}";
    sha256 = "1cbzz98qn8aypp4r5kwwwc9wiq5bwzv51kcsb15xjfs9lz8h3rii";
  };

  buildInputs = [ pybind11 ];

  pythonPath = [ numpy ];

  preBuild = ''
    HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    description = "Python module for text classification and representation learning";
    homepage = https://fasttext.cc/;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}

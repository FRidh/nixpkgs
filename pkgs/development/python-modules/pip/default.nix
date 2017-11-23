{ lib
, buildPythonPackage
, fetchPypi
, bootstrapped-pip
, setuptools
}:

let
  buildFunction = (buildPythonPackage.override {
    pip = bootstrapped-pip;
  });
#   setuptools2 = (setuptools.override {
#     buildPythonPackage = buildFunction;
#   });

in buildFunction rec {
  pname = "pip";
  version = "9.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09f243e1a7b461f654c26a725fa373211bb7ff17a9300058b205c61658ca940d";
  };

  # pip detects that we already have bootstrapped_pip "installed", so we need
  # to force it a little.
  installFlags = [ "--ignore-installed" ];

#   checkInputs = [ mock scripttest virtualenv pretend pytest ];
  buildInputs = [ setuptools ];
  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = lib.licenses.mit;
    homepage = https://pip.pypa.io/;
    priority = 10;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python-json-logger
, jsonschema
, ruamel_yaml
, traitlets
}:

buildPythonPackage rec {
  pname = "jupyter_telemetry";
  version = "0.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "052khyn6h97jxl3k5i2m81xvga5v6vwh5qixzrax4w6zwcx62p24";
  };

  requiredPythonModules = [
    python-json-logger jsonschema ruamel_yaml traitlets
  ];

  meta = with stdenv.lib; {
    description = "Telemetry for Jupyter Applications and extensions";
    homepage = "https://jupyter-telemetry.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}

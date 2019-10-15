{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ypn95swjj93kvdcrvmijmh3vzpr499a3krk923a86m8vlcwcvjm";
  };

  checkInputs = [ pytest mock ];
  pythonPath = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-scheduler";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c6e6edd386ddc4c21d54b1497c3397b970bc127b71809b51bd2391cb1f3d1a14";
  };

  pythonPath = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Scheduler Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/scheduler?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}

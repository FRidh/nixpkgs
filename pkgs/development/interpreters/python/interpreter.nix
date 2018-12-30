{
# Version info
, implementationVersion
, pythonVersion
, sha256
}:

let
  version = with implementationVersion; "${major}.${minor}.${patch}";
  libPrefix = with pythonVersion; {
    cpython = "python${major}.${minor}";
    pypy = "pypy";
  }.implementation;
  sitePackages = "lib/${libPrefix}/site-packages";
  interpreter = "${self}/bin/${executable};

in {
  passthru = {


  };

}
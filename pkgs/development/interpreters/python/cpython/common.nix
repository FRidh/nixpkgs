{ lib
, interpreter   # Name of interpreter, "python" or "pypy".
, version       # Version of the implementation. "${majorVersion}.${minorVersion}.${revisionVersion}.${revisionVersionSuffix}"
, pythonVersion # Version of the Python specification it is compatible with, for example "2.7".
, pythonPackages
}:

let
  versionList = lib.splitString "." version;
  majorVersion = builtins.elemAt versionList 0;
  minorVersion = builtins.elemAt versionList 1;
  revisionVersion = builtins.elemAt versionList 2;
  revisionSuffix = if builtins.length versionList == 4 then builtins.elemAt versionList 3 else "";

  pythonVersionList = lib.splitString "." version;
  pythonMajorVersion = builtins.elemAt versionList 0;
  pythonMinorVersion = builtins.elemAt versionList 1;

  libPrefix = "python${pythonVersion}";

  isPy2 = pythonMajorVersion == 2;
  isPy3 = pythonMajorVersion == 3;

  isPy26 = (pythonMajorVersion == 2) && (pythonMinorVersion == 6);
  isPy27 = (pythonMajorVersion == 2) && (pythonMinorVersion == 7);
  isPy33 = (pythonMajorVersion == 3) && (pythonMinorVersion == 3);
  isPy34 = (pythonMajorVersion == 3) && (pythonMinorVersion == 4);
  isPy35 = (pythonMajorVersion == 3) && (pythonMinorVersion == 5);
  isPy36 = (pythonMajorVersion == 3) && (pythonMinorVersion == 6);

in {
  name = "python-${version}";

  PYTHON_LIB_PREFIX = libPrefix; # Needed for setupHook
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  passthru = {
    inherit version pythonVersion;
    inherit isPy2 isPy3;
    inherit isPy26 isPy27 isPy33 isPy34 isPy35 isPy36;
    inherit zlibSupport sqliteSupport readlineSupport opensslSupport;
    buildEnv = callPackage ../wrapper.nix { python = self; };
    withPackages = import ../with-packages.nix { inherit buildEnv pythonPackages; };
    dbSupport = false;
    sitePackages = "lib/${libPrefix}/site-packages";
    interpreter = "${self}/bin/${executable}";
  };

  meta = with lib; {
    homepage = http://python.org;
    description = "A high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = licenses.psfl;
    platforms = platforms.all;
    maintainers = with maintainers; [ chaoflow domenkozar cstrahan ];
  };
}

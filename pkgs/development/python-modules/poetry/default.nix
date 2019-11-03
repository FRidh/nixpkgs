{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, callPackage
, isPy27, isPy34
, cachecontrol
, cachy
, cleo
, functools32
, glob2
, html5lib
, httpretty
, jsonschema
, lockfile
, pathlib2
, pkginfo
, pyparsing
, pyrsistent
, pytest
, pytest-mock
, requests
, requests-toolbelt
, shellingham
, subprocess32
, tomlkit
, typing
, virtualenv
, python
, writeText
}:

let
  cleo6 = cleo.overridePythonAttrs (oldAttrs: rec {
    version = "0.6.8";
    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "06zp695hq835rkaq6irr1ds1dp2qfzyf32v60vxpd8rcnxv319l5";
    };
  });

  rewriteToml = writeText "update-toml.py" ''
    import sys
    print(sys.path)
    import tomlkit
    with open("pyproject.toml") as fin:
        data = tomlkit.parse(fin.read())

    # Get rid of dependencies
    data["tool"]["poetry"]["dependencies"] = {}

    # Add poetry as build system
    data["build-system"] = {
        "requires": [ "poetry" ],
        "build-backend": "poetry.masonry.api",
    }

    with open("pyproject.toml", "w") as fout:
        fout.write(tomlkit.dumps(data))
  '';

in buildPythonPackage rec {
  pname = "poetry";
  format = "pyproject";
  version = "0.12.17";

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "poetry";
    rev = version;
    sha256 = "004s747wkil5f00r0vjff73r6vhlrrcnfan2k7pl7gyf62wfp02a";
  };

  postPatch = ''
    ${python.interpreter} ${rewriteToml}
  '';

  preBuild = ''
    export PYTHONPATH=".:$PYTHONPATH"
  '';

  propagatedBuildInputs = [
    cachy
    cleo6
    requests
    cachy
    requests-toolbelt
    lockfile
    jsonschema
    pyrsistent
    pyparsing
    cachecontrol
    pkginfo
    html5lib
    shellingham
    tomlkit
  ] ++ lib.optionals (isPy27 || isPy34) [ typing pathlib2 glob2 ]
    ++ lib.optionals isPy27 [ virtualenv functools32 subprocess32 ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
  '';

  # copy the tests to a directory where we have write permissions
  # only do tests on test suites which are pure
  checkInputs = [ pytest httpretty pytest-mock ];
  checkPhase = ''
    HOME=$TMPDIR pytest tests/{mixology,packages,repositories,semver}
  '';

  meta = with lib; {
    homepage = https://github.com/sdispater/poetry;
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}

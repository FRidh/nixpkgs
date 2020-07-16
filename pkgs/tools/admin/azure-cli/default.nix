{ stdenv, lib, python, fetchFromGitHub, installShellFiles }:

let
  version = "2.8.0";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-cli";
    rev = "azure-cli-${version}";
    sha256 = "1jfavxpqa0n6j7vs1233ghgxs5l9099xz4ncgmpj4s826f8chdi8";
  };

  # put packages that needs to be overriden in the py package scope
  py = import ./python-packages.nix { inherit stdenv python lib src version; };
in
py.pkgs.toPythonApplication (py.pkgs.buildAzureCliPackage {
  pname = "azure-cli";
  inherit version src;
  disabled = python.isPy27; # namespacing assumes PEP420, which isn't compat with py2

  sourceRoot = "source/src/azure-cli";

  prePatch = ''
    substituteInPlace setup.py \
      --replace "javaproperties==0.5.1" "javaproperties" \
      --replace "pytz==2019.1" "pytz" \
      --replace "mock~=4.0" "mock"

    # remove namespace hacks
    # remove urllib3 because it was added as 'urllib3[secure]', which doesn't get handled well
    sed -i setup.py \
      -e '/azure-cli-command_modules-nspkg/d' \
      -e '/azure-cli-nspkg/d' \
      -e '/urllib3/d'
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with py.pkgs; [
    colorama
    cryptography
    Fabric
    jsmin
    knack
    mock
    paramiko
    pydocumentdb
    pygments
    pyopenssl
    pytz
    pyyaml
    psutil
    requests
    scp
    six
    sshtunnel
    urllib3
    vsts-cd-manager
    websocket_client
    xmltodict
    javaproperties
    jsondiff
    # urllib3[secure]
    ipaddress
    # shell completion
    argcomplete
  ];

  # TODO: make shell completion actually work
  # uses argcomplete, so completion needs PYTHONPATH to work
  postInstall = ''
    installShellCompletion --bash --name az.bash az.completion.sh
    installShellCompletion --zsh --name _az az.completion.sh

    # remove garbage
    rm $out/bin/az.bat
    rm $out/bin/az.completion.sh
  '';

  # wrap the executable so that the python packages are available
  # it's just a shebang script which calls `python -m azure.cli "$@"`
  postFixup = ''
    wrapProgram $out/bin/az \
      --set PYTHONPATH $PYTHONPATH
  '';

  # almost the entire test suite requires an azure account setup and networking
  # ensure that the azure namespaces are setup correctly and that azure.cli can be accessed
  checkPhase = ''
    cd azure # avoid finding local copy
    ${py.interpreter} -c 'import azure.cli.core; assert "${version}" == azure.cli.core.__version__'
    HOME=$TMPDIR ${py.interpreter} -m azure.cli --help
  '';


  meta = with lib; {
    homepage = "https://github.com/Azure/azure-cli";
    description = "Next generation multi-platform command line experience for Azure";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
})


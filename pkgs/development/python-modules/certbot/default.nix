{ lib
, buildPythonApplication, toPythonApplication
, python
, certbot, runCommand, makeWrapper
, fetchFromGitHub
, ConfigArgParse, acme, configobj, cryptography, distro, josepy, parsedatetime, pyRFC3339, pyopenssl, pytz, requests, six, zope_component, zope_interface
, dialog, mock, gnureadline
, pytest_xdist, pytest, pytestCheckHook, dateutil
}:

buildPythonApplication rec {
  pname = "certbot";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1y0m5qm853i6pcpb2mrf8kjkr9wr80mdrx1qmck38ayvr2v2p5lc";
  };

  sourceRoot = "source/${pname}";

  propagatedBuildInputs = [
    ConfigArgParse
    acme
    configobj
    cryptography
    distro
    josepy
    parsedatetime
    pyRFC3339
    pyopenssl
    pytz
    requests
    six
    zope_component
    zope_interface
  ];

  buildInputs = [ dialog mock gnureadline ];

  checkInputs = [
    dateutil
    pytest
    pytestCheckHook
    pytest_xdist
  ];

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  doCheck = true;

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram "$i" --prefix PATH : "${dialog}/bin:$PATH"
    done
  '';

  # certbot.withPlugins has a similar calling convention as python*.withPackages
  # it gets invoked with a lambda, and invokes that lambda with the python package set matching certbot's:
  # certbot.withPlugins (cp: [ cp.certbot-dns-foo ])
  passthru.withPlugins = f: let
    # call the lambda with python.pkgs, get back a list of plugins
    plugins = (f python.pkgs);

  in toPythonApplication (certbot.overridePythonAttrs (old: {
    pname = old.pname + "-with-plugins";
    propagatedBuildInputs = old.propagatedBuildInputs or [] ++ plugins;
  }));

  meta = with lib; {
    homepage = src.meta.homepage;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
    license = with licenses; [ asl20 ];
  };
}

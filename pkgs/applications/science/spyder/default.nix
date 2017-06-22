{ stdenv, unzip, buildPythonApplication, makeDesktopItem, fetchPypi
# mandatory
, rope
, jedi
, pyflakes
, pygments
, qtconsole
, nbconvert
, sphinx
, pep8
, pylint
, psutil
, qtawesome
, qtpy
, pickleshare
, pyzmq
, chardet
, numpydoc
}:

buildPythonApplication rec {
  pname = "spyder";
  name = "${pname}-${version}";
  version = "3.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0cabd441761d5c439977cba4eb15b72da5874fc7f0d3523ab991670c503f073";
  };

  propagatedBuildInputs =
    [ rope jedi pyflakes pygments qtconsole nbconvert sphinx pep8
    pylint psutil qtawesome qtpy pickleshare pyzmq chardet numpydoc ];

  # There is no test for spyder
  doCheck = false;

  desktopItem = makeDesktopItem {
    name = "Spyder";
    exec = "spyder";
    icon = "spyder";
    comment = "Scientific Python Development Environment";
    desktopName = "Spyder";
    genericName = "Python IDE";
    categories = "Application;Development;Editor;IDE;";
  };

  # Create desktop item
  postInstall = ''
    mkdir -p $out/share/{applications,icons}
    cp  $desktopItem/share/applications/* $out/share/applications/
    cp  spyderlib/images/spyder.svg $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = https://github.com/spyder-ide/spyder/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

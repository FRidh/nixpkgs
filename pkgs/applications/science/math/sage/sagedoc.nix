{ stdenv
, cddlib
, maxima-ecl
, tachyon
, jmol
, sage-src
, env-locations
, sage-with-env
, python2
}:

stdenv.mkDerivation rec {
  version = sage-src.version;
  name = "sagedoc-${version}";


  # Building the documentation has many dependencies, because all documented
  # modules are imported and because matplotlib is used to produce plots.
  buildInputs = [
    cddlib
    jmol
    maxima-ecl
    tachyon
  ] ++ (with python2.pkgs; [
    sagelib
    python2
    psutil
    future
    sphinx
    sagenb
    networkx
    scipy
    sympy
    matplotlib
    pillow
    ipykernel
    jupyter_client
    ipywidgets
    typing
    pybrial
  ]);

  unpackPhase = ''
    export SAGE_DOC_OVERRIDE="$PWD/share/doc/sage"
    export SAGE_DOC_SRC_OVERRIDE="$PWD/docsrc"

    cp -r "${sage-src}/src/doc" "$SAGE_DOC_SRC_OVERRIDE"
    chmod -R 755 "$SAGE_DOC_SRC_OVERRIDE"
  '';

  buildPhase = ''
    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"
    export HOME="$TMPDIR/sage_home"
    mkdir -p "$HOME"

    ${sage-with-env}/bin/sage -python -m sage_setup.docbuild \
      --mathjax \
      --no-pdf-links \
      all html
  '';

  installPhase = ''
    cd "$SAGE_DOC_OVERRIDE"

    mkdir -p "$out/share/doc/sage"
    cp -r html "$out"/share/doc/sage

    # Replace duplicated files by symlinks (Gentoo)
    cd "$out"/share/doc/sage
    mv html/en/_static{,.tmp}
    for _dir in `find -name _static` ; do
          rm -r $_dir
          ln -s /share/doc/sage/html/en/_static $_dir
    done
    mv html/en/_static{.tmp,}
  '';

  doCheck = true;
  checkPhase = ''
    ${sage-with-env}/bin/sage -t --optional=dochtml --all
  '';
}

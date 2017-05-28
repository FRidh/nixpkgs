{ stdenv
# , makeWrapper
}:

drv :

let
  # Create Python environment with our package.
  env = drv.python.withPackages ( ps: with ps; [ drv ]);

in stdenv.mkDerivation rec {
  name = stdenv.lib.removePrefix "${drv.python.libPrefix}-" drv.name;

  unpackPhase = "true";

  # Create symbolic links to the scripts provided by our package.
  # However, we link to the wrapped symbolic links in our environment
  installPhase = ''
    mkdir -p "$out/bin"
    if [ -d ${drv}/bin ]; then
      for prg in ${drv}/bin/*; do
        if [ -f "$prg" ]; then
          echo ${env}/bin/$(basename $prg)
#           makeWrapper "${env}/bin/$(basename $prg)" "$out/bin/$(basename $prg)"
          # It doesn't matter if the path (sys.argv[0]) is different here
          # because it will always use a working script anyway.
          ln -t $out/bin -s ${env}/bin/$(basename $prg)
        fi
      done
    fi
  '';

  # We might want to inherit meta, but we should be careful not to take
  # certain Python-specific attributes.
}


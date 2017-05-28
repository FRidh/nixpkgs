# Create a Python environment through symbolic linking that contains the Python
# packages `libraries`. Additional packages can be exposed to the environment by
# setting `extraPaths`, which adds for each package the folder $out/bin to PATH.

{ stdenv
, python
, buildEnv
, makeWrapper
}:

{ libraries ? []            # Libraries to add to the environment.
, postBuild ? ""            #
, extraPaths ? []           # Extra items to add to PATH of the interpreter and other scripts.
, ignoreCollisions ? false  # Ignore collisions.
}:

# Create a python executable that knows about additional packages.
let
  recursivePthLoader = import ../../python-modules/recursive-pth-loader/default.nix { stdenv = stdenv; python = python; };
  env = (
  let
    # Obtain a list of derivations that have Python modules.
    # These we are going to link.
    libs = [ python ] ++ (python.pkgs.findDerivationsProvidingModules libraries);
    # Extra paths that we need to add to PATH.
    paths = stdenv.lib.unique (stdenv.lib.flatten ( extraPaths ++ (stdenv.lib.catAttrs "extraPaths" libs) ));
  in buildEnv {
    name = "${python.name}-env";

    paths = libs; # Yep, confusing
    inherit ignoreCollisions;

    postBuild = ''
      . "${makeWrapper}/nix-support/setup-hook"

      if [ -L "$out/bin" ]; then
          unlink "$out/bin"
      fi
      mkdir -p "$out/bin"

      for path in ${stdenv.lib.concatStringsSep " " libs}; do
        if [ -d "$path/bin" ]; then
          cd "$path/bin"
          for prg in *; do
            if [ -f "$prg" ]; then
              rm -f "$out/bin/$prg"
              makeWrapper "$path/bin/$prg" "$out/bin/$prg" --set PYTHONHOME "$out" --set NIX_PYTHON_SCRIPT_NAME "$out/bin/$prg" --prefix PATH : "${stdenv.lib.makeBinPath paths}:$out/bin"
            fi
          done
        fi
      done
    '' + postBuild;

    passthru.env = stdenv.mkDerivation {
      name = "interactive-${python.name}-environment";
      nativeBuildInputs = [ env ];

      buildCommand = ''
        echo >&2 ""
        echo >&2 "*** Python 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
        echo >&2 ""
        exit 1
      '';
    };
  }) // {
    inherit python;
    inherit (python) meta;
  };
in env

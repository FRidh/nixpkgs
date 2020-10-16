{ stdenv
, unwrapped
}:

mkDerivation:

args:

let
  args_ = {
    enableParallelBuilding = args.enableParallelBuilding or true;
    nativeBuildInputs = (args.nativeBuildInputs or []) ++ unwrapped.nativeBuildInputs;
    buildInputs = (args.buildInputs or []) ++ unwrapped.buildInputs ++ [ unwrapped ];
  };
in mkDerivation (args // args_)

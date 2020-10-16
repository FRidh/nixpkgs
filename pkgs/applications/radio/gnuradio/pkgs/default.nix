{ mkDerivation
, mkDerivationWith
, callPackage
# We use unwrapped.versionAttr to check what src to give to some packages
, unwrapped
, pkgs
, lib
}:

let
  srcs = import ./srcs.nix {
    inherit pkgs lib;
    ver = unwrapped.versionAttr.major;
  };
in
  # lib.genAttrs (builtins.attrNames srcs)
  # (name: callPackage ./${name}.nix {
    # inherit (srcs.${name}) version src;
  # })
{
  osmosdr = callPackage ./osmosdr.nix {
    inherit (srcs.osmosdr) version src;
  };
  ais = callPackage ./ais.nix {
    inherit (srcs.ais) version src;
  };
  gsm = callPackage ./gsm.nix {
    inherit (srcs.gsm) version src;
  };
  nacl = callPackage ./nacl.nix {
    inherit (srcs.nacl) version src;
  };
  rds = callPackage ./rds.nix {
    inherit (srcs.rds) version src;
  };
  limesdr = callPackage ./limesdr.nix {
    inherit (srcs.limesdr) version src;
  };
}

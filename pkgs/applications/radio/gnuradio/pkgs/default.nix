# callPackage here has gnuradio's `mkDerivation` and `mkDerivationWith` in scope
{ callPackage
}:

{
  osmosdr = callPackage ./osmosdr.nix { };

  ais = callPackage ./ais.nix { };

  gsm = callPackage ./gsm.nix { };

  nacl = callPackage ./nacl.nix { };

  rds = callPackage ./rds.nix { };

  limesdr = callPackage ./limesdr.nix { };
}

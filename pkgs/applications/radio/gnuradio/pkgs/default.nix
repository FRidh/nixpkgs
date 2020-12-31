# callPackage here has gnuradio's `mkDerivation` and `mkDerivationWith` in scope
{ pkgs
, gnuradio # unwrapped gnuradio
}:

with pkgs.lib;

makeScope pkgs.newScope ( self:

let
  callPackage = self.callPackage;

  # Modeled after qt's
  mkDerivationWith = import ../mkDerivation.nix {
    inherit (pkgs) stdenv;
    unwrapped = gnuradio;
  };
  mkDerivation = mkDerivationWith pkgs.stdenv.mkDerivation;

in {

  inherit callPackage mkDerivationWith mkDerivation;

  ### Packages

  inherit gnuradio;

  osmosdr = callPackage ./osmosdr.nix { };

  ais = callPackage ./ais.nix { };

  gsm = callPackage ./gsm.nix { };

  nacl = callPackage ./nacl.nix { };

  rds = callPackage ./rds.nix { };

  limesdr = callPackage ./limesdr.nix { };

})

{ nix
, stdenv
, runCommand
}:

let
  groupname = "nixbld";
  username = "nixbld";
  nbuilders = 32;
in runCommand "nix-setup" {
  inherit groupname username nbuilders;
  inherit (nix) confDir stateDir storeDir;
  inherit (stdenv) shell;
} ''
  mkdir -p $out/bin
  substituteAll ${./nix-setup} $out/bin/nix-setup
  chmod +x $out/bin/nix-setup
''

/*

# New packages

READ THIS FIRST

This module is for official packages in KDE Plasma Mobile. All available packages are
listed in `./srcs.nix`, although a few are not yet packaged in Nixpkgs (see
below).

*/

{
  libsForQt5, lib, fetchgit
}:

let
  srcs = import ./srcs.nix {
    inherit fetchgit;
  };

  mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};

  packages = self: with self;
    let

      propagate = out:
        let setupHook = { writeScript }:
              writeScript "setup-hook" ''
                if [[ "''${hookName-}" != postHook ]]; then
                    postHooks+=("source @dev@/nix-support/setup-hook")
                else
                    # Propagate $${out} output
                    propagatedUserEnvPkgs+=" @${out}@"

                    if [ -z "$outputDev" ]; then
                        echo "error: \$outputDev is unset!" >&2
                        exit 1
                    fi

                    # Propagate $dev so that this setup hook is propagated
                    # But only if there is a separate $dev output
                    if [ "$outputDev" != out ]; then
                        propagatedBuildInputs+=" @dev@"
                    fi
                fi
              '';
        in callPackage setupHook {};

      propagateBin = propagate "bin";

      callPackage = self.newScope {
        inherit propagate propagateBin;

        mkDerivation = args:
          let
            inherit (args) name;
            sname = args.sname or name;
            inherit (srcs.${sname}) src version;

            outputs = args.outputs or [ "out" ];
            hasBin = lib.elem "bin" outputs;
            hasDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasBin && hasDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;

            meta = {
              license = with lib.licenses; [
                # lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
              ];
              platforms = lib.platforms.linux;
              maintainers = with lib.maintainers; [ fridh ];
              homepage = http://www.kde.org;
            } // (args.meta or {});
          in
          mkDerivation (args // {
            name = "${name}-${version}";
            inherit meta outputs setupHook src;
          });
      };

    in {
      plasma-camera = callPackage ./plasma-camera.nix {};
      plasma-phone-components = callPackage ./plasma-phone-components.nix {};
      plasma-settings = callPackage ./plasma-settings.nix {}; 
      simplelogin = callPackage ./simplelogin.nix {};
    };
in
lib.makeScope libsForQt5.newScope packages

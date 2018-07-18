{ lib
, self
, pkgs
, overrides ? (self: super: {})
}:

let

  packages = self: super: {

    linbox = super.linbox.override { withSage = true; };

    # https://trac.sagemath.org/ticket/15980 for tracking of python3 support
    python2 = super.python2.override {
      pkgs = self;
      packageOverrides = import ./python-packages.nix { pkgs = self; };
    };

    env-locations = self.callPackage ./env-locations.nix {
      # Sage expects those in the same directory.
      pari_data = super.symlinkJoin {
      name = "pari_data";
      paths = [
        super.pari-galdata
        super.pari-seadata-small
      ];
      };
      three = super.nodePackages_8_x.three;
      mathjax = super.nodePackages_8_x.mathjax;
      inherit (self.python2.pkgs) cysignals;
    };

    sagedoc = self.callPackage ./sagedoc.nix { };

    sage-src = self.callPackage ./sage-src.nix { };

    sagePython2Env = let
      pythonRuntimeDeps = with self.python2.pkgs; [
        sagelib
        pybrial
        sagenb
        cvxopt
        networkx
        service-identity
        psutil
        sympy
        fpylll
        matplotlib
        scipy
        ipywidgets
        rpy2
        sphinx
        typing
        pillow
      ];
    in self.python2.buildEnv.override {
        extraLibs = pythonRuntimeDeps;
        ignoreCollisions = true;
    } // { extraLibs = pythonRuntimeDeps; }; # make the libs accessible

    sage-env = self.callPackage ./sage-env.nix {
      inherit (self.python2.pkgs) sagelib;
    };

    sage-with-env = self.callPackage ./sage-with-env.nix {
      three = super.nodePackages_8_x.three;
    };

    sage = self.callPackage ./sage.nix { };

    sage-wrapper = self.callPackage ./sage-wrapper.nix {};

    # update causes issues
    # https://groups.google.com/forum/#!topic/sage-packaging/cS3v05Q0zso
    # https://trac.sagemath.org/ticket/24735
    singular = super.singular.overrideAttrs (oldAttrs: {
      name = "singular-4.1.0p3";
      src = pkgs.fetchurl {
        url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-0/singular-4.1.0p3.tar.gz";
        sha256 = "105zs3zk46b1cps403ap9423rl48824ap5gyrdgmg8fma34680a4";
      };
    });

    # sage currently uses an unreleased version of pari
    pari = (super.pari.override { withThread = false; }).overrideAttrs (attrs: rec {
      version = "2.10-1280-g88fb5b3"; # on update remove pari-stackwarn patch from `sage-src.nix`
      src = pkgs.fetchurl {
        url = "mirror://sageupstream/pari/pari-${version}.tar.gz";
        sha256 = "19gbsm8jqq3hraanbmsvzkbh88iwlqbckzbnga3y76r7k42akn7m";
      };
    });

    # With openblas (64 bit), the tests fail the same way as when sage is build with
    # openblas instead of openblasCompat. Apparently other packages somehow use flints
    # blas when it is available. Alternative would be to override flint to use
    # openblasCompat.
    flint = super.flint.override { withBlas = false; };

    # https://trac.sagemath.org/ticket/24824
    glpk = super.glpk.overrideAttrs (attrs: rec {
      version = "4.63";
      name = "glpk-${version}";
      src = super.fetchurl {
        url = "mirror://gnu/glpk/${name}.tar.gz";
        sha256 = "1xp7nclmp8inp20968bvvfcwmz3mz03sbm0v3yjz8aqwlpqjfkci";
      };
      patches = (attrs.patches or []) ++ [
      # Alternatively patch sage with debians
      # https://sources.debian.org/data/main/s/sagemath/8.1-7/debian/patches/t-version-glpk-4.60-extra-hack-fixes.patch
      # The header of that debian patch contains a good description of the issue. The gist of it:
      # > If GLPK in Sage causes one error, and this is caught by Sage and recovered from, then
      # > later (because upstream GLPK does not clear the "error" flag) Sage will append
      # > all subsequent terminal output of GLPK into the error_message string but not
      # > actually forward it to the user's terminal. This breaks some doctests.
        (super.fetchpatch {
          name = "error_recovery.patch";
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/error_recovery.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "0z99z9gd31apb6x5n5n26411qzx0ma3s6dnznc4x61x86bhq31qf";
        })

        # Allow setting a exact verbosity level (OFF|ERR|ON|ALL|DBG)
        (super.fetchpatch {
          name = "exact_verbosity.patch";
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/glp_exact_verbosity.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "15gm5i2alqla3m463i1qq6jx6c0ns6lip7njvbhp37pgxg4s9hx8";
        })
      ];
    });

    # https://trac.sagemath.org/ticket/22191
    ecl = super.ecl_16_1_2;

    # https://trac.sagemath.org/ticket/25674
    R = super.R.overrideAttrs (attrs: rec {
      name = "R-3.4.4";
      src = pkgs.fetchurl {
        url = "http://cran.r-project.org/src/base/R-3/${name}.tar.gz";
        sha256 = "0dq3jsnwsb5j3fhl0wi3p5ycv8avf8s5j1y4ap3d2mkjmcppvsdk";
      };
    });

    openblas-blas-pc = self.callPackage ./openblas-pc.nix { name = "blas"; };
    openblas-cblas-pc = self.callPackage ./openblas-pc.nix { name = "cblas"; };
    openblas-lapack-pc = self.callPackage ./openblas-pc.nix { name = "lapack"; };

    # Multiple palp dimensions need to be available and sage expects them all to be
    # in the same folder.
    palp = self.symlinkJoin {
      name = "palp-${super.palp.version}";
      paths = [
        (super.palp.override { dimensions = 4; doSymlink = false; })
        (super.palp.override { dimensions = 5; doSymlink = false; })
        (super.palp.override { dimensions = 6; doSymlink = true; })
        (super.palp.override { dimensions = 11; doSymlink = false; })
      ];
    };
  };
in lib.fix' (lib.extends overrides (lib.extends packages pkgs.__unfix__))


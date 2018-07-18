{ pkgs }:

self: super: {
  # python packages that appear unmaintained and were not accepted into the nixpkgs
  # tree because of that. These packages are only dependencies of the more-or-less
  # deprecated sagenb. However sagenb is still a default dependency and the doctests
  # depend on it.
  # See https://github.com/NixOS/nixpkgs/pull/38787 for a discussion.
  flask-oldsessions = self.callPackage ./flask-oldsessions.nix {};
  flask-openid = self.callPackage ./flask-openid.nix {};
  python-openid = self.callPackage ./python-openid.nix {};

  pybrial = self.callPackage ./pybrial.nix {};

  sagelib = self.callPackage ./sagelib.nix { };

  sagenb = self.callPackage ./sagenb.nix {
    mathjax = pkgs.nodePackages_8_x.mathjax;
  };
}
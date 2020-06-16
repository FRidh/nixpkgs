{ python3
}:

{ name
, localSystem ? builtins.currentSystem
}:

let
  # TODO: Don't use Python's setup hook. We need a custom build.
  python = python3.override {
    packageOverrides = self: super: {
      python-stdenv = with python3.pkgs; buildPythonPackage {
        pname = "python-stdenv";
        version = "dev";
        src = ./stdenv;
        format = "pyproject";

        nativeBuildInputs = [ 
          flit-core
        ];

        propagatedBuildInputs = [
          multipledispatch
        ];
      };
    };
  };
  python-stdenv = python.pkgs.python-stdenv;
    

in derivation rec {
  inherit name;

  builder = "${python-stdenv}/bin/stdenv";

  __structuredAttrs = true;
  system = localSystem;

}
{ pkgs
}:

with pkgs;

{
  test-simple-build = callPackage (
    { buildDerivation
    }: buildDerivation {
        name = "test";
    }) { };
}
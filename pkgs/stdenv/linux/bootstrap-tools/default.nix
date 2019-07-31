{ system, bootstrapFiles }:

derivation {
  name = "bootstrap-tools";

  builder = "${bootstrapFiles.busybox}";

  args = [ "ash" "-e" ./scripts/unpack-bootstrap-tools.sh ];

  tarball = bootstrapFiles.bootstrapTools;
#   __structuredAttrs = true;

  inherit system;

  # Needed by the GCC wrapper.
  langC = true;
  langCC = true;
  isGNU = true;
}

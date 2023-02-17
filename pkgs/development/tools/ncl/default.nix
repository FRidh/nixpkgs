{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeWrapper
, tcsh
, bzip2
, fontconfig
, gomp
, gfortran6
, libICE
, libSM
, libXaw
, libXext
, libXmu
, libXt
, libXrender
, openssl_1_1
# , fetchFromGitHub
# , pkg-config
# , gfortran
# , cairo
# , libpng
# , netcdf
# , zlib
}:

let
  gfortran = gfortran6;
in stdenv.mkDerivation rec {
  pname = "ncl";
  version = "6.6.2";

  src = fetchurl {
    url = "https://www.earthsystemgrid.org/api/v1/dataset/ncl.662.dap/file/ncl_ncarg-6.6.2-Debian9.8_64bit_gnu630.tar.gz";
    hash = "sha256-H/sosaN8XFLSOA0CrKUjJYRkbwRfrXgylAIxIPkF+SQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    bzip2
    fontconfig
    gomp
    gfortran.cc
    libICE
    libSM
    libXaw
    libXext
    libXmu
    libXt
    libXrender
    openssl_1_1
  ];


  dontBuild = true;

  installPhase = ''
    mkdir -p $out $dev $bin
    mv bin $bin
    mv include $dev
    mv lib $out

    substituteInPlace "$bin/bin/ncl_convert2nc" --replace "/bin/rm" "rm"

    find "$bin/bin" -type f -executable -exec sed -i "s:/bin/csh:${tcsh}/bin/tcsh:" \{} \;

    for executable in `ls $bin/bin`; do
      wrapProgram "$bin/bin/$executable" --prefix "PATH" ":" "${lib.makeBinPath [ gfortran ]}:${placeholder "bin"}/bin" --set "NCARG_ROOT" "$out" --set "NCARG_BIN" "$bin"
    done
  '';

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  # src = fetchFromGitHub {
  #   owner = "NCAR";
  #   repo = "ncl";
  #   rev = version;
  #   hash = "sha256-kXDWTphGvsjHzwQvrW2715NIMFzUrXTDTLjjXYcjdnk=";
  # };

  # nativeBuildInputs = [
  #   gfortran
  #   pkg-config
  # ];

  # buildInputs = [
  #   cairo
  #   libpng
  #   netcdf
  #   zlib
  # ];


}

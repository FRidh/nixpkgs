{ stdenv
, fetchFromBitbucket
, cmake
, makeWrapper
, python
}:

let
  pythonEnv = python.withPackages(ps: with ps; [ pandas pyside ply h5py psutil matplotlib twisted pygments ]);
in stdenv.mkDerivation rec {
  pname = "sympathy";
  version = "1.4.0";
  name = "${pname}-${version}";

  src = fetchFromBitbucket {
    owner = "sysess";
    repo = "sympathy-for-data-public";
    rev = "c59938769eb33b82c835ad6114f0686412ad5248";
    sha256 = "0vjmk68j56iwvspfi2j2cqhs91bav08ga21i78vidz1wzxkcfd2y";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper $src/Sympathy/syg.sh $out/bin/sympathy \
      --prefix PATH : ${pythonEnv}/bin
  '';
}
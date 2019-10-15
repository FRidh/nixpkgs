{ stdenv, fetchFromGitHub, makeWrapper, cmake, llvmPackages, kernel
, flex, bison, elfutils, python, luajit, netperf, iperf, libelf
, systemtap
}:

python.pkgs.buildPythonApplication rec {
  version = "0.10.0";
  name = "bcc-${version}";

  srcs = [
    (fetchFromGitHub {
      owner  = "iovisor";
      repo   = "bcc";
      rev    = "v${version}";
      sha256 = "0qbqygj7ia494fbira9ajavvnxlpffx1jlzbb1vsf1wa8h3y4xn1";
      name   = "bcc";
    })

    # note: keep this in sync with the version that was used at the time of the
    # tagged release!
    (fetchFromGitHub {
      owner  = "libbpf";
      repo   = "libbpf";
      rev    = "0e37e0d03ac99987401e4496d3d76d44237b9963";
      sha256 = "0wjf9dhvqkwiwnygzikamrgmpxgq77h2pxx6mi4pnbw0lxlppivr";
      name   = "libbpf";
    })
  ];
  sourceRoot = "bcc";
  format = "other";

  buildInputs = with llvmPackages; [
    llvm clang-unwrapped kernel
    elfutils luajit netperf iperf
    systemtap.stapBuild flex
  ];

  patches = [
    # This is needed until we fix
    # https://github.com/NixOS/nixpkgs/issues/40427
    ./fix-deadlock-detector-import.patch
  ];

  pythonPath = [ python.pkgs.netaddr ];
  nativeBuildInputs = [ makeWrapper cmake flex bison ]
    # libelf is incompatible with elfutils-libelf
    ++ stdenv.lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

  cmakeFlags = [
    "-DBCC_KERNEL_MODULES_DIR=${kernel.dev}/lib/modules"
    "-DREVISION=${version}"
    "-DENABLE_USDT=ON"
    "-DENABLE_CPP_API=ON"
  ];

  postPatch = ''
    substituteAll ${./libbcc-path.patch} ./libbcc-path.patch
    patch -p1 < libbcc-path.patch
  '';

  preConfigure = ''
    chmod -R u+w ../libbpf/
    rmdir src/cc/libbpf
    (cd src/cc && ln -svf ../../../libbpf/ libbpf)
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share
    rm -r $out/share/bcc/tools/old
    mv $out/share/bcc/tools/doc $out/share
    mv $out/share/bcc/man $out/share/

    find $out/share/bcc/tools -type f -executable -print0 | \
    while IFS= read -r -d ''$'\0' f; do
      bin=$out/bin/$(basename $f)
      if [ ! -e $bin ]; then
        ln -s $f $bin
      fi
    done

    sed -i -e "s!lib=.*!lib=$out/bin!" $out/bin/{java,ruby,node,python}gc
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/bcc/tools" "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Dynamic Tracing Tools for Linux";
    homepage    = https://iovisor.github.io/bcc/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ ragge mic92 thoughtpolice ];
  };
}

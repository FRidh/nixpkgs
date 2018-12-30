let
  common = {

    postInstall = {

        symlinkPymallocInterpreter = ''
          ln -s "$out/include/python${majorVersion}m" "$out/include/python${majorVersion}"
        '';

        paxmark = ''
          paxmark E $out/bin/python${majorVersion}
        '';

        removeTests = ''
        # needed for some packages, especially packages that backport
        # functionality to 2.x from 3.x
        for item in $out/lib/python${majorVersion}/test/*; do
        if [[ "$item" != */test_support.py*
            && "$item" != */test/support
            && "$item" != */test/libregrtest
            && "$item" != */test/regrtest.py* ]]; then
            rm -rf "$item"
        else
            echo $item
        fi
        done
        touch $out/lib/python${majorVersion}/test/__init__.py
        '';

        determinismRemoveWindowsInstallers = ''
        # Determinism: Windows installers were not deterministic.
        # We're also not interested in building Windows installers.
        find "$out" -name 'wininst*.exe' | xargs -r rm -f
        '';

        determinismRebuildByteCode = ''
            # Determinism: rebuild all bytecode
            # We exclude lib2to3 because that's Python 2 code which fails
            # We rebuild three times, once for each optimization level
            find $out -name "*.py" | $out/bin/python -m compileall -q -f -x "lib2to3" -i -
            find $out -name "*.py" | $out/bin/python -O -m compileall -q -f -x "lib2to3" -i -
            find $out -name "*.py" | $out/bin/python -OO -m compileall -q -f -x "lib2to3" -i -
        '';

        determinismRemoveRetainedDependencies = ''
        # Get rid of retained dependencies on -dev packages, and remove
        # some $TMPDIR references to improve binary reproducibility.
        # Note that the .pyc file of _sysconfigdata.py should be regenerated!
        for i in $out/lib/python${majorVersion}/_sysconfigdata.py $out/lib/python${majorVersion}/config-${majorVersion}m/Makefile; do
            sed -i $i -e "s|-I/nix/store/[^ ']*||g" -e "s|-L/nix/store/[^ ']*||g" -e "s|$TMPDIR|/no-such-path|g"
        done
        '';

        python3AsDefault = ''
        # Use Python3 as default python
        ln -s "$out/bin/idle3" "$out/bin/idle"
        ln -s "$out/bin/pydoc3" "$out/bin/pydoc"
        ln -s "$out/bin/python3" "$out/bin/python"
        ln -s "$out/bin/python3-config" "$out/bin/python-config"
        ln -s "$out/lib/pkgconfig/python3.pc" "$out/lib/pkgconfig/python.pc"
        '';

        manyLinux = ''
        # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
        echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py
        '';

    };
  };


  interpreters = {
    common = stdenv.mkDerivation {

    };

    python27 = common.overrideAttrs(oldAttrs: {
    });

    python3 = common.overrideAttrs(oldAttrs: {
    });

    python35 = python3.overrideAttrs(oldAttrs: {

    });

  };


  };


{ writeShellScript
, jq
, python3
}:

{
  wrapper = writeShellScript "wrapper" ''
    filename=$0
    wrappersfile=$1
    executable="${jq}/bin/jq -e --arg filename $filename '.|.[$filename].executable' $wrappersfile"
    args="${jq}/bin/jq -e --arg filename $filename '.|.[$filename].args // empty' $wrappersfile"
    exec -a $filename $executable $args
  '';

  test = let
    jsonfile = builtins.toFile "wrappers.json" builtins.toJSON {
        "bin/"
    };
  writeShellScriptBin "testscript" ''
    #!{wrapper} ${jsonfile}
    echo("testscript works")
  '';

  test = let
    json = toJSON {
      "$filename" = {
        "executable" = "bin/mytest";
        "arguments" = [
            "bar"
        ];
      };
    };
  in runCommandNoCC "test" { } ''

    # Create a test script
    mkdir -p $out/bin
    # patchShebangs should write the interpreter to the json file
    # along with its already existing arguments
    cat << EOF > $out/bin/mytest
    #!${python3.interpreter}
    import os
    import sys
    #assert os.environ["FOO"] == "foo"
    assert sys.argv[1] == "bar"
    EOF
    chmod +x $out/bin


    mkdir -p $out/nix-support
    jsonfile="$out/nix-support/wrappers.json"
    touch $out/nix-support/

    # Perform the test
    $out/bin/mytest

  '';

}

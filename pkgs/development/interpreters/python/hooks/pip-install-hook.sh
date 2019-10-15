# Setup hook for pip.
echo "Sourcing pip-install-hook"

declare -a pipInstallFlags

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    pushd dist || return 1
    @pythonInterpreter@ -m pip install ./*.whl --no-index --prefix="$out" --no-cache $pipInstallFlags --build tmpbuild
    popd || return 1

    # Record Python dependencies in file like we do with propagated build inputs.
    # We typically do not need this in Python environments, however, we do need it
    # if *importing* from a single package in a build to ensure the dependencies are present.
    # Note the interpreter should also be added in the build. We prefer to avoid propagating
    # it.
    mkdir -p $out/nix-support
    echo $pythonPath > $out/nix-support/python-deps

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "$dontUsePipInstall" ] && [ -z "$installPhase" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi

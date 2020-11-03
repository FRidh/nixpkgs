echo "Sourcing create-python-interpreter-hook.sh"

createPythonInterpreterPhase() {

    if [ -z ${sitePackages-} ]; then
        echo "sitePackages needs to be set"
        exit 1
    fi
    mkdir -p "$out/nix-support"
    cp @setupHook@ "$out/nix-support/setup-hook"
    substituteAllInPlace "$out/nix-support/setup-hook"
}

preConfigurePhases+=" createPythonInterpreterPhase"
# Hook that propagates wrapper arguments up to the
# python interpreter buildEnv environment.
echo "Sourcing makewrapperargs-load-hook.sh"

makeWrapperArgsLoadPhase() {
    echo "Executing makeWrapperArgsLoadPhase"
    # Load the arguments from all the dependencies.
    # Note: this hook *must* run after makeWrapperArgsSavePhase to
    # avoid an exponential duplication of the wrapper arguments.
    for path in "$@"; do
        if [ -f "$path/nix-support/make-wrapper-args" ]; then
            makeWrapperArgs+=$(cat "$path/nix-support/make-wrapper-args")
        fi
    done
}

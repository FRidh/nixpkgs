# Hook that propagates wrapper arguments up to the
# python interpreter buildEnv environment.
echo "Sourcing makewrapperargs-save-hook.sh"

makeWrapperArgsSavePhase() {
    # Store the arguments for use by other derivations
    # and the python interpreter derivation.
    echo "Executing makeWrapperArgsSavePhase"

    mkdir -p "$out/nix-support"
    if [ ${#qtWrapperArgs[@]} -ne 0 ]; then
        printf '%s\n' "${qtWrapperArgs[@]}" >> "$out/nix-support/make-wrapper-args"
    fi
    if [ ${#gappsWrapperArgs[@]} -ne 0 ]; then
        printf '%s\n' "${gappsWrapperArgs[@]}" >> "$out/nix-support/make-wrapper-args"
    fi
    if [ ${#makeWrapperArgs[@]} -ne 0 ]; then
        printf '%s\n' "${makeWrapperArgs[@]}" >> "$out/nix-support/make-wrapper-args"
    fi
}

postFixupHooks+=(makeWrapperArgsSavePhase)

# Setup hook for modifying a wheel's dependencies.
echo "Sourcing python-modify-dependencies-hook.sh"

pythonModifyDependencies(){
    
    echo "Executing pythonModifyDependencies"
    # if -n "${pythonRemoveDependencyConstraints-}"; then
    eval @script@
    # fi
    echo "Finished executing pythonModifyDependencies"
}

if [ -z "${dontUsePythonModifyDependencies-}" ]; then
    preInstallPhases+=" pythonModifyDependencies"
fi
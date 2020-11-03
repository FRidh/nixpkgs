{ makeSetupHook }:

# This setup hook creates the setup hook each Python interpreter should have.
makeSetupHook {
  name = "create-python-interpreter-hook.sh";
  substitutions = {
    setupHook = ./setup-hook.sh;
  };
} ./create-python-interpreter-hook.sh

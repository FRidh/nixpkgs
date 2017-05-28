{ devEnv, pythonPackages }:

f: let packages = f pythonPackages; in devEnv { libraries = packages; }

"""
This is a Nix-specific module that recursively adds paths that are on
`NIX_PYTHONPATH` to `sys.path`. In order to process possible `.pth` files
`site.addsitedir` is used.

The paths listed in `PYTHONPATH` are added to `sys.path` afterwards, but they
will be added before the entries we add here and thus take precedence.
"""
import site
import os
import functools

paths = os.environ.get('NIX_PYTHONPATH', '').split(':')
functools.reduce(lambda k, p: site.addsitedir(p, k), paths, site._init_pathinfo())


"""
Set `sys.argv[0] of our script.
"""
import sys

def argv_setter_hook(path):
    if hasattr(sys, 'argv'):
        # Remove this hook
        sys.path_hooks.remove(argv_setter_hook)

        import os
        import functools
        import site

        sys.argv[0] = os.environ.get('NIX_PYTHON_SCRIPT_NAME', sys.argv[0])
        functools.reduce(lambda k, p: site.addsitedir(p, k), paths, site._init_pathinfo())

    raise ImportError # Let the real import machinery do its work

sys.path_hooks[:0] = [argv_setter_hook]
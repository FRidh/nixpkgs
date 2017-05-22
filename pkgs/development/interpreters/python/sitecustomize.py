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

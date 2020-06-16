"""
stdenv
======
"""

import json
import os


def main():
    print("hello")

    with open(".attrs.json") as fin:
        attributes = json.load(fin)

    print(attributes)
    print(os.environ)
    out = os.environ.get("out")
    os.listdir(".")
    print("dirs")
    print(os.getcwd())
    if out:
        os.mkdir(out)


__version__ = "0.0.1"

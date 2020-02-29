#!@pythonInterpreter@

import glob
import os

from wheel.wheelfile import WheelFile

def lines_to_remove(lines):
    """Yield booleans indicating whether the lines are to be removed."""

    purge_list = os.env.get("pythonRemoveDependencyConstraints")

    def remove_line(line):
        """Remove the line in case it contains a dependency that's in our purge list."""
        if line.startswith("Requires-Dist:"):
            for dep in purge_list:
                if dep in line:
                    print("Will remove the line {}".format(line))
                    return True
        return False

    return map(remove_line)


def change_dependencies(fin):
    lines = fin.readlines()
    filter(lambda boolean,zip(lines_to_remove(lines), lines)
    
    fin.write("\n".join(filter(remove_line, lines)))


def modify_wheel(filename):
    print("Will modify wheel in {}".format(filename))
    wheel = WheelFile(filename, mode="r")

    # Find metadata file
    files = list(filter(lambda filename: filename.endswith("METADATA"), wheel.namelist()))
    metadata_file = files[0]
    print("Found METADATA file {}".format(metadata_file))
    
    with wheel.open(metadata_file, "w") as fin:
        change_dependencies(fin)
        
    wheel.close()


def main():
    print("hello")
    for wheel in glob.iglob("dist/*.whl"):
        print("wheel")
        modify_wheel(wheel)


if __name__ == "__main__":
    main()

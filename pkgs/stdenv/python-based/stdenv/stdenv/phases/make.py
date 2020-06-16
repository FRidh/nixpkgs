"""
Phases to run ``make``.
"""


from stdenv.phases import Phase, order


class MakeBuildPhase(Phase):
    """Make build phase."""

    def run(self):
        result = subprocess.run(["make", "build"])


class MakeBuildCheckPhase(Phase):
    """Make build check phase."""
    
    def run(self):
        result = subprocess.run(["make", "check"])


class MakeInstallPhase(Phase):
    """Make install phase."""
    
    def run(self):
        result = subprocess.run(["make", "install"])


# Run make phases in the following order
phase_orders.register_list([
    MakeBuildPhase,
    MakeBuildCheckPhase,
    MakeInstallPhase,
])

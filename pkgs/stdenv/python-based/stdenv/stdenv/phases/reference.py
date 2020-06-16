

class Reference(Phase):
    """Reference phases."""

    def run(self):
        pass


class ReferenceUnpack(Reference):
    """Reference unpack phase."""


class ReferenceBuild(Reference):
    """Reference build phase."""


class ReferenceBuildCheckPhase(Reference):
    """Reference build check phase."""


class ReferenceInstall(Reference):
    """Reference install phase."""


class ReferenceInstallCheck(Reference):
    """Reference install check phase."""


# Run make phases in the following order
phase_orders.register_list([
    ReferenceUnpack,
    ReferenceBuild,
    ReferenceBuildCheckPhase,
    ReferenceInstall,
    ReferenceInstallCheck,
])
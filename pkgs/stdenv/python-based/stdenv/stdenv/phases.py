"""
Support phases using multiple-dispatch.
"""

import subprocess

from typing import List


class Phase:

    def __eq__(self, other):
        return False


class PhaseRunner:  # TODO: singleton
    """Phase runner that determines in what order phases are executed."""

    def __init__(self):
        self._orders = set()

    @property
    def orders(self):
        yield from self._orders

    @property
    def phases(self) -> List:
        """Yield the phases in order.
        
        TODO: Topological sort.
        """
        return NotImplemented

    def register_from_tuple(self, item: collections.Sequence):
        """Register phase order from a tuple consisting of two values."""
        if not isinstance(item, collections.Sequence):
            raise ValueError("Incorrect type, a sequency needs to be passed in.")
        if not len(item) == 2:
            raise ValueError("Incorrect amount of values. The sequence needs to consist of 2 values.")
        if not issubclass(item[0], Phase):
            raise ValueError("Incorrect type, a subclass of Phase should be passed in.")
        if not issubclass(item[1], Phase):
            raise ValueError("Incorrect type, a subclass of Phase should be passed in.")
        self._orders.add(item)

    def register_from_tuples(self, iterable: collections.Iterable):
        """Register phase order from an iterable of tuples."""
        for item in iterable:
            self.register_from_tuple(item)

    def register_from_list(self, iterable: collections.Iterable):
        """Register phase order from an iterable."""

        def pairwise(iterable):
            "s -> (s0,s1), (s1,s2), (s2, s3), ..."
            a, b = tee(iterable)
            next(b, None)
            return zip(a, b)
        
        yield from pairwise(iterable)
    
    def check_relative_order(phase_a: Phase, phase_b: Phase) -> bool:
        """Check whether ``aa`` is executed before ``b``."""
        return phases.index(a) < phases.index(b)


PhaseRunner()

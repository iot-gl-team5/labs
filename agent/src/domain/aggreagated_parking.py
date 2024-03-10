from dataclasses import dataclass

from domain.gps import Gps

@dataclass
class AggregatedParking:
    empty_count: int
    gps: Gps
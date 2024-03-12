from dataclasses import dataclass

from domain.gps import Gps

@dataclass
class AggregatedParkingData:
    empty_count: int
    gps: Gps
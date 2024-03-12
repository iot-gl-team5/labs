from csv import reader, DictReader
from marshmallow import Schema
from datetime import datetime
from domain.accelerometer import Accelerometer
from domain.gps import Gps
from domain.aggregated_parking_data import AggregatedParkingData
from schema.accelerometer_schema import AccelerometerSchema
from schema.gps_schema import GpsSchema
import config
from enum import Enum


class ParkingDatasource:
    def __init__(
        self,
        parking_filename: str
    ) -> None:
        self.reader = CSVParkingDatasourceReader(parking_filename)
        

    def read(self) -> AggregatedParkingData:
        """Method return data received from sensors"""
        try:
            parking = self.reader.read()

            return parking
        except Exception as e:
            print(f"Error while reading data from sensors: {e}")

    def startReading(self, *args, **kwargs):
        """Method is called before reading data from sensors"""
        self.reader.startReading()

    def stopReading(self, *args, **kwargs):
        """Method is called after reading data from sensors"""
        self.reader.stopReading()

class CSVParkingDatasourceReader:
    filename: str
    reader: DictReader

    def __init__(self, filename):
        self.filename = filename

    def startReading(self):
        self.file = open(self.filename, 'r')
        self.reader = DictReader(self.file)

    def read(self):
        row = next(self.reader, None)

        if row is None:
            self.reset()
            row = next(self.reader, None)

        # return self.schema.load(row)
        columnList = row.split(',')
        empty_count = columnList[0]
        gps = Gps(columnList[1], columnList[2])
        aggregated_parking_data = AggregatedParkingData(empty_count, gps)
        return aggregated_parking_data

    def reset(self):
        self.file.seek(0)
        self.reader = DictReader(self.file)

    def stopReading(self):
        if self.file:
            self.file.close()
from marshmallow import Schema, fields
from schema.gps_schema import GpsSchema


class AggregatedParkingSchema(Schema):
    empty_count = fields.Number()
    gps = fields.Nested(GpsSchema)
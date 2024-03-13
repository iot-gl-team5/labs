import asyncio
import json
from datetime import datetime
import websockets
from kivy import Logger
from pydantic import BaseModel, field_validator
from config import (STORE_HOST, STORE_PORT)


class ProcessedAgentData(BaseModel):
    road_state: str
    user_id: int
    x: float
    y: float
    z: float
    latitude: float
    longitude: float
    timestamp: datetime

    @classmethod
    @field_validator("timestamp", mode="before")
    def check_timestamp(cls, value):
        if isinstance(value, datetime):
            return value
        try:
            return datetime.fromisoformat(value)
        except (TypeError, ValueError):
            raise ValueError(
                "Invalid timestamp format."
            )

# tipical receive is: {'road_state': 'large pits', 'agent_data': {'user_id': 1,
# 'accelerometer': {'x': -16569.0, 'y': -1653.0, 'z': -3967.0}, 
# 'gps': {'latitude': 30.516823703248743, 'longitude': 50.454483843951586}, 
# 'timestamp': '2024-03-13T15:51:08.732695'}}
def received_dict_to_processed_agent_data(received_dict):
    return ProcessedAgentData(
        road_state=received_dict["road_state"],
        user_id=received_dict["agent_data"]["user_id"],
        x=received_dict["agent_data"]["accelerometer"]["x"],
        y=received_dict["agent_data"]["accelerometer"]["y"],
        z=received_dict["agent_data"]["accelerometer"]["z"],
        latitude=received_dict["agent_data"]["gps"]["latitude"],
        longitude=received_dict["agent_data"]["gps"]["longitude"],
        timestamp=received_dict["agent_data"]["timestamp"],
    )


class Datasource:
    def __init__(self, user_id: int):
        self.index = 0
        self.user_id = user_id
        self.connection_status = None
        self._new_points = []
        asyncio.ensure_future(self.connect_to_server())

    def get_new_points(self):
        Logger.debug(self._new_points)
        points = self._new_points
        self._new_points = []
        return points

    async def connect_to_server(self):
        uri = f"ws://{STORE_HOST}:{STORE_PORT}/ws/{self.user_id}"
        while True:
            Logger.debug("CONNECT TO SERVER")
            async with websockets.connect(uri) as websocket:
                self.connection_status = "Connected"
                try:
                    while True:
                        data = await websocket.recv()
                        parsed_data = json.loads(data)
                        self.handle_received_data(parsed_data)
                except websockets.ConnectionClosedOK:
                    self.connection_status = "Disconnected"
                    Logger.debug("SERVER DISCONNECT")

    def handle_received_data(self, data):
        Logger.info(f"Received data: {data}")
        processed_agent_data = received_dict_to_processed_agent_data(data)
        new_points = [
            (
                processed_agent_data.longitude,
                processed_agent_data.latitude,
                processed_agent_data.road_state,
            )
        ]
        self._new_points.extend(new_points)

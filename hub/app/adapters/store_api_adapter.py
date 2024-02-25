import json
import logging
from typing import List

import requests

from app.entities.processed_agent_data import ProcessedAgentData
from app.interfaces.store_gateway import StoreGateway


class StoreApiAdapter(StoreGateway):
    def __init__(self, api_base_url, buffer_size=10):
        self.api_base_url = api_base_url
        self.buffer_size = buffer_size
        self.buffer = []

    def save_data(self, processed_agent_data_batch: List[ProcessedAgentData]) -> bool:
        """
        Save the processed road data to the Store API.
        Parameters:
            processed_agent_data_batch (List[ProcessedAgentData]): Processed road data to be saved.
        Returns:
            bool: True if the data is successfully saved, False otherwise.
        """
        try:
            # Add the batch of data to the buffer
            self.buffer.extend(processed_agent_data_batch)

            # Check if the buffer size has been reached
            if len(self.buffer) >= self.buffer_size:
                # If buffer size is reached, send the data
                success = self.send_data(self.buffer)
                # Clear the buffer after sending
                self.buffer.clear()
                return success
            else:
                return True
        except Exception as e:
            logging.error(f"Error occurred: {e}")
            return False

    def send_data(self, data: List[ProcessedAgentData]) -> bool:
        """
        Send the accumulated data to the Store API.
        """
        url = f"{self.api_base_url}/agent_data"
        try:
            json_data = [processed_data.dict() for processed_data in data]
            response = requests.post(url, json=json_data)
            if response.status_code == 201:
                return True
            else:
                logging.error(f"Failed to save data. Status code: {response.status_code}")
                return False
        except Exception as e:
            logging.error(f"Error occurred: {e}")
            return False

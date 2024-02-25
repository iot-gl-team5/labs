import json
import logging
from typing import List

import pydantic_core
import requests

from app.entities.processed_agent_data import ProcessedAgentData
from app.interfaces.store_gateway import StoreGateway

class StoreApiAdapter(StoreGateway):
    def __init__(self, api_base_url):
        self.api_base_url = api_base_url

    def save_data(self, processed_agent_data_batch: List[ProcessedAgentData]) -> bool:
        """
        Save the processed road data to the Store API.
        Parameters:
            processed_agent_data_batch (List[ProcessedAgentData]): Processed road data to be saved.
        Returns:
            bool: True if the data is successfully saved, False otherwise.
        """
        url = f"{self.api_base_url}/agent_data"  # Construct the API endpoint URL
        try:
            json_data = [processed_data.dict() for processed_data in processed_agent_data_batch]

            response = requests.post(url, json=json_data)

            if response.status_code == 201:
                return True
            else:
                logging.error(f"Failed to save data. Status code: {response.status_code}")
                return False
        except Exception as e:
            logging.error(f"Error occurred: {e}")
            return False

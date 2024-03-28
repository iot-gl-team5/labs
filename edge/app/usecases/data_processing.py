from app.entities.agent_data import AgentData
from app.entities.processed_agent_data import ProcessedAgentData
import logging
import numpy as np
import keras

RANGE_NORMAL = (14000, 18000)
RANGE_SMALL_PITS = ((12000, 14000), (18000, 20000))

agent_data_cache = dict()

def process_agent_data(
    agent_data: AgentData,
    model=None,
) -> ProcessedAgentData:
    """
    Process agent data and classify the state of the road surface.
    Parameters:
        agent_data (AgentData): Agent data that containing accelerometer, GPS, and timestamp.
    Returns:
        processed_data_batch (ProcessedAgentData): Processed data containing the classified state of the road surface and agent data.
    """
    road_state = None
    z_acceleration = agent_data.accelerometer.z
    if model is None:
        logging.info("Using rule-based to predict road state")
        if RANGE_NORMAL[0] < z_acceleration < RANGE_NORMAL[1]:
            road_state = "normal"
        elif any(range_[0] < z_acceleration < range_[1] for range_ in RANGE_SMALL_PITS):
            road_state = "small pits"
        else:
            road_state = "large pits"

        logging.info(f"Prediction: {road_state}, z_acceleration: {z_acceleration}")
    else:
        logging.info("Using machine learning to predict road state")
        user_id = agent_data.user_id

        if user_id not in agent_data_cache:
            agent_data_cache[user_id] = []
        # cache contains last 20 z acceleration data per user
        agent_data_cache[user_id].append(z_acceleration)
        if len(agent_data_cache[user_id]) > 20:
            agent_data_cache[user_id].pop(0)
        if len(agent_data_cache[user_id]) < 20:
            road_state = "unknown"
        else:
            prediction = model.predict(np.array([agent_data_cache[user_id]]))[0]
            # prediction is in format of [0.0, 0.0, 1.0] for example
            # where the first index is normal, second is small pits, and third is large pits
            road_state = ["normal", "small pits", "large pits"][np.argmax(prediction)]

            logging.info(f"Prediction for user {user_id}: {road_state}, data {agent_data_cache[user_id]}")

    return ProcessedAgentData(road_state=road_state, agent_data=agent_data)

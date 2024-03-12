from paho.mqtt import client as mqtt_client
import json
import time
from schema.aggregated_data_schema import AggregatedDataSchema
from schema.aggregated_parking_schema import AggregatedParkingSchema
from file_datasource import FileDatasource
from parking_datasource import ParkingDatasource
import config


def connect_mqtt(broker, port):
    """Create MQTT client"""
    print(f"CONNECT TO {broker}:{port}")

    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print(f"Connected to MQTT Broker ({broker}:{port})!")
        else:
            print("Failed to connect {broker}:{port}, return code %d\n", rc)
            exit(rc)  # Stop execution

    client = mqtt_client.Client()
    client.on_connect = on_connect
    client.connect(broker, port)
    client.loop_start()
    return client


def publish(client, topic, datasource, delay, schema_type):
    datasource.startReading()
    time.sleep(delay)
    data = datasource.read()
    msg = schema_type().dumps(data)
    result = client.publish(topic, msg)
    # result: [0, 1]
    status = result[0]
    if status == 0:
        pass
        # print(f"Send `{msg}` to topic `{topic}`")
    else:
        print(f"Failed to send message to topic {topic}")


def run():
    # Prepare mqtt client
    client = connect_mqtt(config.MQTT_BROKER_HOST, config.MQTT_BROKER_PORT)
    # Prepare datasource
    datasource = FileDatasource("data/accelerometer.csv", "data/gps.csv")
    parking_datasource = ParkingDatasource("data/parking.csv")
    # Infinity publish data
    while True:
        publish(client, config.MQTT_TOPIC, datasource, config.DELAY, AggregatedDataSchema)
        publish(client, config.MQTT_PARKINGTOPIC, parking_datasource, config.DELAY, AggregatedParkingSchema)


if __name__ == "__main__":
    run()

# Renogy-DCC50S-modbus

This project is to pull stats out of a Renogy DCC50S solar charge controller.

The connection will be made via modbus/RS485. 

The end state will be to pull required stats and formatted into a payload for ingestion into an InfluxDb instance.

Please copy config.py.example to config.py and input your own creds and MQTT
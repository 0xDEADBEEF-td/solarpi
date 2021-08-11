#!/usr/bin/python3
import minimalmodbus
import json
import paho.mqtt.publish as publish
from datetime import datetime
import config

instrument = minimalmodbus.Instrument(config.serial_dev, 1)  # port name, slave address (in decimal)
instrument.serial.baudrate = 9600
instrument.serial.bytesize = 8
instrument.serial.parity = minimalmodbus.serial.PARITY_NONE
instrument.serial.stopbits = 2
instrument.serial.timeout  = 1
instrument.address = 1  # this is the slave address number
instrument.mode = minimalmodbus.MODE_RTU   # rtu or ascii mode
instrument.clear_buffers_before_each_transaction = True

mqttPublishPayload = json.dumps({
	"auxSoc": instrument.read_register(256),
	"auxVoltage": instrument.read_register(257,1),
	"maxCharge": instrument.read_register(258,2),
	"controllerTemp": instrument.read_register(259),
	"auxTemp": instrument.read_register(259),
	"altVoltage": instrument.read_register(260,1),
	"altAmps": instrument.read_register(261,2),
	"altWatts": instrument.read_register(262),
	"solVoltage": instrument.read_register(263,1),
	"solAmps": instrument.read_register(264,2),
	"solWatts": instrument.read_register(265),
	"dayCount": instrument.read_register(271),
	"chargeState": instrument.read_register(276),
	"faultBits1": instrument.read_register(277),
	"faultBits2": instrument.read_register(278),
	"timestamp": str(datetime.now())
})

try:
	publish.single(
		topic=config.topic,
		payload=mqttPublishPayload,
		retain=True,
        hostname=config.broker_url,
        port=config.broker_port,
        auth=config.broker_auth,
	#	tls=config.broker_tls,
        client_id=config.client_id,
        qos=0
	)
except:
	print ("Error")

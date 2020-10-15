#!/usr/bin/ruby

require_relative "coordinates"
require_relative "iot_agent"
require_relative "context_broker"

include Coordinates
include Agent
include ContextBroker

# Esto va a venir de un dump de posiciones algún día.
coordinates_array = Coordinates::BUS_405

device_id = ARGV[0]
coordinate_index = 0

while true
    coordinate_index +=1
    coordinates = coordinates_array.dig(coordinate_index)

    send_measurement(device_id, coordinates_array.dig(coordinate_index))

    sleep 5
end

#!/usr/bin/ruby

require_relative "coordinates"
require_relative "iot_agent"
require_relative "context_broker"

include Coordinates
include Agent
include ContextBroker

device_id = ARGV[0]
linea = ARGV[1]
sublinea = ARGV[2]
sentido = ARGV[3]
file_for_coordinates = ARGV[4]

coord_array = []

if sublinea != 'd'
    coord_array = get_coordinates(file_for_coordinates, linea, sublinea, sentido)
else
    coord_array = get_desvio(linea)
end

description = "Notify pygeoapi of changes in a bus location"
id_pattern = "Vehicle.*"
sensor_attributes = ["device_id", "linea", "sublinea", "sentido", "location"]
notification_attributes = ["location", "linea"]
create_subscriptions(description, id_pattern, sensor_attributes, notification_attributes)

coord_array.each do |coord|
    send_measurement(device_id, { location: coord.to_s.tr('[]', '') })

    sleep 5
end

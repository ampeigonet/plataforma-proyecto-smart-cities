require_relative "iot_agent"
require_relative "context_broker"

include Agent
include ContextBroker

provide_service_group()

device_id = ARGV[0]
linea = ARGV[1]
sublinea = ARGV[2]
sentido = ARGV[3]

create_gps_sensor(device_id, linea, sublinea, sentido)

while true do
  puts "Context Broker data for sensor #{device_id}, context: #{linea} #{sublinea} #{sentido}"

  get_bus_data(device_id)

  sleep 10
end

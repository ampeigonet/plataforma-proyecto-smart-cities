require_relative "iot_agent"
require_relative "context_broker"

include Agent
include ContextBroker

# siempre es vehicle, pero se podría leer de la entrada también
provide_service_group()

device_id = ARGV[0]
line = ARGV[1]

sensor_id = create_gps_sensor(device_id, line)

while true do
  puts "Context Broker data for sensor #{device_id}"

  get_bus_data(device_id)

  sleep 10
end

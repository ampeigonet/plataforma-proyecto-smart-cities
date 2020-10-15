module Agent
  require 'net/http'
  require 'uri'
  require 'json'

  CONTEXT_BROKER = 'http://orion:1026'
  IOT_AGENT_S = 'http://localhost:4041'
  IOT_AGENT_N = 'http://localhost:7896'
  API_KEY = 'api_key'
  HEADERS = {'Content-Type': 'application/json', 'fiware-service': 'openiot', 'fiware-servicepath': '/'}

  def provide_service_group()
    uri = URI.parse("#{IOT_AGENT_S}/iot/services")

    payload = {
      services: [
        {
          apikey: API_KEY,
          cbroker: CONTEXT_BROKER,
          entity_type: 'Vehicle',
          resource: '/iot/d'
        }
      ]
    }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
    request.body = payload.to_json

    response = http.request(request)
  end

  def create_gps_sensor(id, bus_number)
    uri = URI.parse("#{IOT_AGENT_S}/iot/devices")

    payload = {
      devices: [
        {
          device_id: id.to_s,
          entity_name: "urn:ngsi-ld:Vehicle:#{id}",
          entity_type: "Vehicle",
          attributes: [
            { object_id: "location", name: "location", type: "geo:point" }
          ],
          static_attributes: [
            { name: "linea", type: "linea", value: bus_number.to_s }
          ]
        }
      ]
    }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
    request.body = payload.to_json

    response = http.request(request)
  end

  def send_measurement(device_id, location)
    uri = URI.parse("#{IOT_AGENT_N}/iot/json?k=#{API_KEY}&i=#{device_id}")

    payload = {
      location: location.to_s.tr('[]', '')
    }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type': 'text/plain'})
    request.body = payload.to_json

    response = http.request(request)

    puts response
  end
end

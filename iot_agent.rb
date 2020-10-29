module Agent
  require 'net/http'
  require 'uri'
  require 'json'

  CONTEXT_BROKER = 'http://orion:1026'.freeze
  IOT_AGENT_S = 'http://localhost:4041'.freeze
  IOT_AGENT_N = 'http://localhost:7896'.freeze
  API_KEY = 'api_key'.freeze
  HEADERS = { 'Content-Type': 'application/json', 'fiware-service': 'openiot', 'fiware-servicepath': '/' }.freeze

  def provide_service_group(type)
    payload = {
      services: [
        {
          apikey: API_KEY,
          cbroker: CONTEXT_BROKER,
          entity_type: "#{type}",
          resource: '/iot/json'
        }
      ]
    }

    do_create_service_group(payload)
  end

  def create_gps_sensor(id, linea, sublinea, sentido)
    payload = {
      devices: [
        {
          device_id: id.to_s,
          entity_name: "urn:ngsi-ld:Vehicle:#{id}",
          entity_type: 'Vehicle',
          static_attributes: [
            { name: "linea", type: "Text", value: linea.to_s },
            { name: "sublinea", type: "Text", value: sublinea.to_s },
            { name: "sentido", type: "Text", value: sentido.to_s }
          ],
          attributes: [
            { object_id: 'location', name: 'location', type: 'geo:point' }
          ]
        }
      ]
    }

    do_create_sensor(payload)
  end

  def create_beach_sensor(id, beach_id, location, type)
    payload = {
      devices: [
        {
          device_id: id.to_s,
          entity_name: "urn:ngsi-ld:#{type}-sensor:#{id}",
          entity_type: 'Device',
          static_attributes: [
            { name: "id", type: "Text", value: id.to_s },
            { name: "location", type: "geo:point", value: location.to_s },
            { name: "beach_id", type: "Text", value: beach_id.to_s },
            { name: "type", type: "Text", value: type.to_s }
          ],
          attributes: [
            { object_id: "value", name: "value", type: "Text" }
          ]
        }
      ]
    }
    do_create_sensor(payload)
  end

  def send_measurement(device_id, payload)
    puts device_id
    uri = URI.parse("#{IOT_AGENT_N}/iot/json?k=#{API_KEY}&i=#{device_id}")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type': 'application/json'})
    request.body = payload.to_json

    response = http.request(request)

    puts "Sending measurement #{payload[:location].to_s}"
  end

  private 

  def do_create_sensor(payload)
    uri = URI.parse("#{IOT_AGENT_S}/iot/devices")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
    request.body = payload.to_json

    response = http.request(request)
  end

  def do_create_service_group(payload)
    uri = URI.parse("#{IOT_AGENT_S}/iot/services")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
    request.body = payload.to_json

    response = http.request(request)
  end
end

module Agent
  require 'net/http'
  require 'uri'
  require 'json'

  CONTEXT_BROKER = 'http://orion:1026'.freeze
  IOT_AGENT_S = 'http://localhost:4041'.freeze
  IOT_AGENT_N = 'http://localhost:7896'.freeze
  API_KEY = 'api_key'.freeze
  HEADERS = { 'Content-Type': 'application/json', 'fiware-service': 'openiot', 'fiware-servicepath': '/' }.freeze

  def provide_service_group
    uri = URI.parse("#{IOT_AGENT_S}/iot/services")

    payload = {
      services: [
        {
          apikey: API_KEY,
          cbroker: CONTEXT_BROKER,
          entity_type: 'Vehicle',
          resource: '/iot/json'
        }
      ]
    }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
    request.body = payload.to_json

    response = http.request(request)
  end

  def create_gps_sensor(id, linea, sublinea, sentido)
    uri = URI.parse("#{IOT_AGENT_S}/iot/devices")

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

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
    request.body = payload.to_json

    response = http.request(request)
  end

  def send_measurement(device_id, location)
    puts device_id
    uri = URI.parse("#{IOT_AGENT_N}/iot/json?k=#{API_KEY}&i=#{device_id}")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type': 'application/json'})
    request.body = { location: location.to_s.tr('[]', '') }.to_json

    response = http.request(request)

    puts "Sending measurement #{location.to_s}"
  end
end

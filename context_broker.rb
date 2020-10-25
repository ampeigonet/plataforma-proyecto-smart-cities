module ContextBroker
  require 'net/http'
  require 'uri'
  require 'json'

  CONTEXT_BROKER = 'http://localhost:1026'

  def get_bus_data(device_id)
    uri = URI.parse("#{CONTEXT_BROKER}/v2/entities/urn:ngsi-ld:Vehicle:#{device_id}")
    request = Net::HTTP::Get.new(uri)
    request["fiware-Service"] = "openiot"
    request["fiware-Servicepath"] = "/"

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    puts response.body
  end
end

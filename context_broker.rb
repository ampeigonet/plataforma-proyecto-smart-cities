module ContextBroker
  require 'net/http'
  require 'uri'
  require 'json'
  require 'cgi'

  CONTEXT_BROKER = 'http://localhost:1026'

  def create_subscriptions(description, id_pattern, sensor_attributes, notification_attributes)
    payload = {
      "description": description,
      "subject": {
        "entities": [
          {
            "idPattern": id_pattern
          }
        ],
        "condition": {
          "attrs": notification_attributes
        }
      },
      "notification": {
        "httpCustom": {
          "url": "http://pygeoapi:5000/processes/test/jobs",
          "headers": {
            "Content-Type": "application/json"
          },
          "method": "POST",
          "payload": encode_to_json_string(sensor_attributes)
        },
        "attrs": notification_attributes,
        "attrsFormat": "keyValues",
        "metadata": ["dateCreated", "dateModified"]
      },
      "throttling": 1
    }

    uri = URI.parse("#{CONTEXT_BROKER}/v2/subscriptions/")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request["fiware-Service"] = "openiot"
    request["fiware-Servicepath"] = "/"
    request.body = payload.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    puts response
    puts response.body
  end

  def encode_to_json_string(attributes)
    res = "{%22inputs%22%3A%5B"
    attributes.each do |attribute|
      object_string = "%7B"
      object_string += "%22id%22%3A%22#{attribute}%22%3A%2C"

      value = attribute == "timestamp" ? "${TimeInstant}" : "${#{attribute}}"
      object_string += "%22value%22%3A%22#{value}%22%2C"

      object_string += "%22value%22%3A%22text%2Fplain%22"

      object_string += "%7D"

      res += object_string + "%2C"
    end
    res = res.delete_suffix('%2C')
    res += "%5D}"
    res
  end

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

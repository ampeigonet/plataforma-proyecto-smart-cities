#!/usr/bin/ruby

require 'date'
require_relative "coordinates"

include Coordinates

# Esto va a venir de un dump de posiciones algún día.
coordinates_array = Coordinates::BUS_405

# NGSI-LD representation
def ngsi_ld_formatted_data(bus_number, coordinates)
  {
    "id": "urn:ngsi-ld:Vehicle:vehicle:bus:#{bus_number}",
    "vehicleType": {
      "type": "Property",
      "value": "bus"
    },
    "category": {
        "type": "Property",
        "value": ["public"]
    },
    "name": {
        "type": "Property",
        "value": "Bus number #{bus_number}"
    },
    "vehiclePlateIdentifier": {
        "type": "Property",
        "value": "Matricula #{bus_number}"
    },
    "refVehicleModel": {
        "type": "Relationship",
        "object": "urn:ngsi-ld:VehicleModel:vehiclemodel:econic"
    },
    "location": {
        "type": "GeoProperty",
        "value": {
            "type": "Point",
            "coordinates": coordinates
        },
        "observedAt": DateTime.now.iso8601()
    },
    "@context": [
      "https://schema.lab.fiware.org/ld/context",
      "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
    ]
  }
end

bus_number = 405
coordinate_index = 0

# Acá probablemente agreguemos otras líneas y tengamos que abrir varios procesos
while true
  coordinates = coordinates_array.dig(coordinate_index)

  data = ngsi_ld_formatted_data(bus_number, coordinates)
  puts data

  coordinate_index +=1
  sleep 5
end

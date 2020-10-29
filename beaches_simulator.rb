#!/usr/bin/ruby
require 'json'
require_relative "sensors/beach/beach"
require_relative "iot_agent"
require_relative "context_broker"

include Agent
include ContextBroker

beaches_data_json_path = ARGV[0]

beaches_data_json = JSON.parse(File.read(beaches_data_json_path))

beaches = []
beaches_data_json.each do |beach_data|
  beaches << Beach.new(
    beach_data["id"],
    beach_data["name"],
    beach_data["location"],
    beach_data["people_sensors"],
    beach_data["tide_sensors"],
    beach_data["uv_sensors"],
    beach_data["water_quality_sensors"],
    beach_data["people_capacity"],
    true
  )
  Agent.provide_service_group("Device")
end

threads = []
beaches.each do |beach|
  threads << Thread.new { beach.start }
end

threads.each do |thread|
  thread.join
end

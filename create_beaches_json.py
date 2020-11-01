import json
import sys

if __name__ == "__main__":
  sensor_types = ["agua", "banderas", "uv", "personas"]
  translated_sensor_types = {
    "agua": "water_quality",
    "banderas": "tide",
    "uv": "uv",
    "personas": "people"
  }
  beaches = []
  beach_geojson = sys.argv[1]
  with open(beach_geojson) as geo_file:
    beaches_data = json.load(geo_file)
    for beach in beaches_data["features"]:
      beach_data = {
        "id": beach["properties"]["id"],
        "name": beach["properties"]["Nombre"],
        "people_capacity": 1000,
        "location": "field not used, soon to be deleted",
        "people_sensors": [],
        "tide_sensors": [],
        "uv_sensors": [],
        "water_quality_sensors": []
      }
      beaches.append(beach_data)

  for sensor_type in sensor_types:
    geojson_sensor_file = f"sensores_{sensor_type}.geojson"
    with open(geojson_sensor_file) as geo_file:
      sensor_data = json.load(geo_file)
      for sensor in sensor_data["features"]:
        for beach in beaches:
          if beach["id"] != sensor["properties"]["id_playa"]:
            continue
          beach[f"{translated_sensor_types[sensor_type]}_sensors"].append({
            "id": sensor["properties"]["id"],
            "location": sensor["geometry"]["coordinates"],
            "value_max_range": 1,
            "value_min_range": 2,
            "random_seed": 1,
            "random_std_deviation": 1,
            "frozen": False
          })

  target_file = sys.argv[2]
  with open(target_file, 'w+') as output_file:
    json.dump(beaches, output_file, indent=2)

  print(f"beaches json generated in {target_file}")

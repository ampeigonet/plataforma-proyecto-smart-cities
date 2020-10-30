require_relative 'beach_sensor'
require_relative "../../iot_agent"

class Beach
  attr_accessor :id
  attr_accessor :name
  attr_accessor :current_people

  def initialize(id, name, location, people_sensors, tide_sensors, uv_sensors, water_quality_sensors, people_capacity, debug = false)
    @id = id
    @name = name
    @location = location

    @people_sensors = people_sensors.map { |sensor_data| create_sensor(sensor_data, "people") }
    @tide_sensors = tide_sensors.map { |sensor_data| create_sensor(sensor_data, "tide") }
    @uv_sensors = uv_sensors.map { |sensor_data| create_sensor(sensor_data, "uv") }
    @water_quality_sensors = water_quality_sensors.map { |sensor_data| create_sensor(sensor_data, "water_quality") }

    @people_capacity = people_capacity
    @current_people = 0

    @max_pop_inc_tick = 5
    @pop_dec_tick = 10
    @max_dec_tick = 15

    @debug = debug
  end

  def start
    ticks = 0
    while true
      if ticks % 1 == 0
        send_data(@people_sensors, ticks, false, true)
      end

      if ticks % 100 == 0
        send_data(@tide_sensors, ticks)
      end

      if ticks % 30 == 0
        send_data(@uv_sensors, ticks)
      end

      if ticks % 100 == 0
        send_data(@water_quality_sensors, ticks)
      end

      if @debug
        puts "current people: #{@current_people}"
        puts ''
      end

      ticks += 1
      sleep 1
    end
  end

  private

  def create_sensor(sensor_data, type)
    Agent.create_beach_sensor(sensor_data["id"], @id, sensor_data["location"], type)
    BeachSensor.new(
      sensor_data["id"],
      sensor_data["location"],
      sensor_data["value_max_range"],
      sensor_data["value_min_range"],
      sensor_data["random_seed"],
      sensor_data["random_std_deviation"],
      sensor_data["random_enabled"],
      type
    )
  end

  def send_data(sensors, ticks, freeze = false, is_people = false)
    if is_people
      sensors.each do |sensor|
        debug_string = @debug ? 'people' : ""
        @current_people += sensor.send_and_generate(debug_string)

        adjust_mean_and_std(sensors, ticks)

        adjust_based_on_people(sensors)

        sensor.frozen = freeze
      end
    else
      sensors.each do |sensor|
        reading = sensor.send_and_generate
        sensor.frozen = freeze
      end
    end
  end

  def adjust_based_on_people(sensors)
    if @current_people == 0
      kill_all(sensors)
    elsif @current_people + @people_sensors.count * @people_sensors[0].value_min_range <= 0
      new_min_value = -(@current_people / @people_sensors.count).floor
      set_mean_std_max_min_params(sensors, new_min_value, 1, new_min_value + 1, new_min_value, @debug)
    elsif @people_capacity <= @current_people + @people_sensors.count * @people_sensors[0].value_max_range
      new_max_value = ((@people_capacity - @current_people) / @people_sensors.count).floor
      set_mean_std_max_min_params(sensors, new_max_value, 1, new_max_value, new_max_value - 1, @debug)
    end
  end

  def set_mean_std_max_min_params(sensors, mean, std, max, min, debug = false)
    sensors.each do |sensor|
      sensor.set_mean_std_max_min_params(mean, std, max, min, debug)
    end
  end

  def kill_all(sensors)
    sensors.each do |sensor|
      sensor.alive = false
    end
  end

  def adjust_mean_and_std(sensors, ticks)
    if @max_pop_inc_tick <= ticks && ticks <= @pop_dec_tick
      sensors.each do |sensor|
        sensor.set_mean_std_max_min_params(10, 4, 14, 6)
      end
    elsif @pop_dec_tick <= ticks && ticks <= @max_dec_tick
      sensors.each do |sensor|
        sensor.set_mean_std_max_min_params(0, 3, 4, -4)
      end
    elsif @max_dec_tick <= ticks
      sensors.each do |sensor|
        sensor.set_mean_std_max_min_params(-10, 4, -6, -14)
      end
    end
  end
end

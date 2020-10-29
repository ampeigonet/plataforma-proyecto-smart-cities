require_relative "../../helpers/math_helper"

class BeachSensor
  attr_accessor :id
  attr_accessor :location

  attr_accessor :value_max_range 
  attr_accessor :value_min_range 
  attr_accessor :random_seed
  attr_accessor :random_std_deviation
  attr_accessor :frozen
  attr_accessor :alive

  def initialize(id, location, value_max_range, value_min_range, random_seed, random_std_deviation, frozen, type)
    @id = id
    @location = location
    @value_max_range  = value_max_range
    @value_min_range  = value_min_range
    @random_seed = random_seed
    @random_std_deviation = random_std_deviation
    @frozen = frozen
    @type = type
    @alive = true
    
    @math_processor = Maths.new
    Kernel.srand(random_seed)
    @math_processor.initialize_gaussian(5, 2)

    @current_reading = @math_processor.mean((value_min_range..value_max_range).to_a)
  end

  def send_and_generate(debug_type = '')
    return 0 unless alive

    reading = generate_data
    if debug_type != ''
      puts "sensor#{id} min: #{value_min_range}"
      puts "sensor#{id} max: #{value_max_range}"
      puts "sensor#{id} #{debug_type} has reading #{reading}"
    end

    payload = { "value": reading.to_s }
    Agent.send_measurement(@id, payload)
    reading
  end

  def set_mean_std_max_min_params(mean, std, max, min, debug = false)
    change_gaussian_mean(mean)
    change_gaussian_std(std)
    @value_max_range = max
    @value_min_range = min

    if debug
      puts 'changed values:'
      puts "sensor#{id} mean: #{mean}"
      puts "sensor#{id} std: #{std}"
      puts "sensor#{id} min: #{value_min_range}"
      puts "sensor#{id} max: #{value_max_range}"
    end
  end

  private

  def generate_data
    raise 'math module not initialized' if @math_processor == nil

    raise 'sth went wrong; maxrange < minrange' if value_max_range < value_min_range

    valid = false
    return @current_reading if (@frozen)

    while !valid do
      @current_reading = @math_processor.rand.round
      valid = value_min_range <= @current_reading && @current_reading <= value_max_range
    end
    @current_reading
  end

  def change_gaussian_mean(mean)
    @math_processor.change_gaussian_mean(mean)
  end

  def change_gaussian_std(stddev)
    @math_processor.change_gaussian_std(stddev)
  end
end
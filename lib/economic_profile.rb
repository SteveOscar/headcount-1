require 'pry'
require_relative 'error_classes'

class EconomicProfile
  attr_reader :district, :economic_data

  def initialize(data)
    @district = data.values[0]
    @economic_data = {data.keys[1] => data.values[1]}
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

end

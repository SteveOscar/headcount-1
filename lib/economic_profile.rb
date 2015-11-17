require 'pry'
require_relative 'error_classes'

class EconomicProfile
  attr_reader :district, :economic_data, :name

  def initialize(data)
    @district = data.values[0]
    @name = district
    @economic_data = {data.keys[1] => data.values[1]}
  end

  def estimated_median_household_income_in_year(year)
    binding.pry
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

end

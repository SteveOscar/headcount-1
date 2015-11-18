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
    raise UnknownDataError.new unless (2005..2013).include?(year)
    incomes = economic_data[:median_household_income].map do |k, v|
      v if k[0] <= year && k[1] >= year
    end
    incomes.compact.reduce(:+) / incomes.length
  end

  def median_household_income_average
    total = economic_data[:median_household_income].map do |k, v|
      v
    end
    total.reduce(:+) / total.length
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError.new unless (1995..2013).include?(year)
    economic_data[:children_in_poverty][year]
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

end

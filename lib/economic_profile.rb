require 'pry'
require_relative 'error_classes'

class EconomicProfile
  attr_reader :district, :economic_data, :name

  def initialize(data)
    @district = data.values[0]
    @name = district
    @economic_data = data_input_source(data)
  end

  def data_input_source(data)
    if data.keys.length > 3
      data
    else
      {data.keys[1] => data.values[1]}
    end
  end

  def estimated_median_household_income_in_year(year)
    raise UnknownDataError.new unless (economic_data[:median_household_income].keys.join.to_s.include?(year.to_s))
    incomes = economic_data[:median_household_income].map do |k, v|
      v if k[0] <= year && k[1] >= year
    end
    truncate(incomes.compact.reduce(:+) / incomes.compact.length)
  end

  def median_household_income_average
    total = economic_data[:median_household_income].map { |k, v| v }
    total.reduce(:+) / total.length
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError.new unless (1995..2013).include?(year)
    economic_data[:children_in_poverty][year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError.new unless (2000..2014).include?(year)
    economic_data[:free_or_reduced_price_lunch][year][:percentage]
    #economic_data[:free_or_reduced_price_lunch]["Eligible for Free or Reduced Lunch"][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError.new unless (2000..2014).include?(year)
    economic_data[:free_or_reduced_price_lunch][year][:total]
    #economic_data[:free_or_reduced_price_lunch]["Eligible for Free or Reduced Lunch"][year][:total].to_i
  end

  def title_i_in_year(year)
    raise UnknownDataError.new unless economic_data[:title_i].keys.join.to_s.include?(year.to_s)
    economic_data[:title_i][year]
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

end

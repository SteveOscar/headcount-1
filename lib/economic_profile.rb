require 'pry'
require_relative 'error_classes'

class EconomicProfile
  attr_reader :district, :economic_data

  def initialize(data)
    @district = data.values[0]
    @economic_data = data_input_source(data)
  end

  def estimated_median_household_income_in_year(year)
    error_check(:median_household_income, year)
    incomes = economic_data[:median_household_income].map do |k, v|
      v if k[0] <= year && k[1] >= year
    end
    divide_results(incomes)
  end

  def divide_results(incomes)
    truncate(incomes.compact.reduce(:+) / incomes.compact.length)
  end

  def median_household_income_average
    total = economic_data[:median_household_income].map { |k, v| v }
    total.reduce(:+) / total.length
  end

  def children_in_poverty_in_year(year)
    error_check(:children_in_poverty, year)
    economic_data[:children_in_poverty][year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    error_check(:free_or_reduced_price_lunch, year)
    economic_data[:free_or_reduced_price_lunch][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    error_check(:free_or_reduced_price_lunch, year)
    economic_data[:free_or_reduced_price_lunch][year][:total]
  end

  def title_i_in_year(year)
    error_check(:title_i, year)
    economic_data[:title_i][year]
  end

  def data_input_source(data)
    data.keys.length > 3 ? data : {data.keys[1] => data.values[1]}
  end

  def error_check(data_type, year)
    raise UnknownDataError.new unless yr_check(data_type, year)
  end

  def yr_check(data_type, year)
    (economic_data[data_type].keys.join.to_s).include?(year.to_s)
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

end

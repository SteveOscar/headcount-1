require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require 'pry'

class EconomicProfileTest < Minitest::Test

  def test_can_instantiate_district
    ep = EconomicProfile.new({name: "ACADEMY 20"})
    assert_equal "ACADEMY 20", ep.name
  end

  def test_estimated_median_household_income_in_year_method
    ep = EconomicProfile.new({name: "ACADEMY 20"})
    answer = ep.estimated_median_household_income_in_year(2007)
    assert_equal "ACADEMY 20", ep.name
  end

end

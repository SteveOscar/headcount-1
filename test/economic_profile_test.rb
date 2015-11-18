require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require './lib/economic_profile_repository'
require 'pry'

class EconomicProfileTest < Minitest::Test
  attr_reader :epr

  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
                    :economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"
                    }})
  end

  def test_can_instantiate_district
    ep = EconomicProfile.new({name: "ACADEMY 20"})
    assert_equal "ACADEMY 20", ep.name
  end

  def test_economic_profile_object_has_name
    ep = EconomicProfile.new({name: "ACADEMY 20"})
    assert_equal "ACADEMY 20", ep.name
  end

  def test_it_has_data
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal Hash, ep.economic_data.class
  end

  def test_estimated_median_household_income_in_year_method
    example = epr.find_by_name("ACADEMY 20")
    answer = example.estimated_median_household_income_in_year(2007)
    assert_equal 51721.8, answer
  end

  def test_estimated_median_household_income_in_year_method_with_different_object
    example = epr.find_by_name("BOULDER VALLEY RE 2")
    answer = example.estimated_median_household_income_in_year(2007)
    assert_equal 39487.6, answer
  end

end

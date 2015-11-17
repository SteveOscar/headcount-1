require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile_repository'
require 'pry'

class EconomicProfileRepositoryTest < Minitest::Test

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

  def test_can_parse_data_correctly_for_economic_profile_objects
    assert_equal "COLORADO", epr.economic_profile.first.district
  end

  def test_bla_bla
    example = epr.find_by_name("ACADEMY 20")
    example.estimated_median_household_income_in_year(2007)

  end



end

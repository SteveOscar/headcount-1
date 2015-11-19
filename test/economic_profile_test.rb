require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require './lib/economic_profile_repository'
require 'pry'

class EconomicProfileTest < Minitest::Test
  attr_reader :epr, :example

  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
                    :economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"
                    }})
    @example = epr.find_by_name("ACADEMY 20")
  end

  def test_can_instantiate_district
    ep = EconomicProfile.new({district: "ACADEMY 20"})
    assert_equal "ACADEMY 20", ep.district
  end

  def test_economic_profile_object_has_name
    ep = EconomicProfile.new({disrict: "ACADEMY 20"})
    assert_equal "ACADEMY 20", ep.district
  end

  def test_it_has_data
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal Hash, ep.economic_data.class
  end

  def test_estimated_median_household_income_in_year_method
    answer = example.estimated_median_household_income_in_year(2007)
    assert_equal 86203.0, answer
  end

  def test_estimated_median_household_income_in_year_method_with_different_object
    example = epr.find_by_name("BOULDER VALLEY RE 2")
    answer = example.estimated_median_household_income_in_year(2007)
    assert_equal 65812.666, answer
  end

  def test_estimated_median_household_income_raises_unknown_data_error
    example = epr.find_by_name("BOULDER VALLEY RE 2")
    assert_raises UnknownDataError do
      example.estimated_median_household_income_in_year(2004)
    end
  end

  def test_median_household_income_average
    answer = example.median_household_income_average
    assert_equal 87635.4, answer
  end

  def test_children_in_poverty_in_year
    example2 = epr.find_by_name("MONTROSE COUNTY RE-1J")
    answer = example.children_in_poverty_in_year(2004)
    answer2 = example2.children_in_poverty_in_year(2004)
    assert_equal 0.034, answer
    assert_equal 0.142, answer2
  end

  def test_children_in_poverty_in_year_with_no_data_returns_error ##added
    assert_raises UnknownDataError do
      example.children_in_poverty_in_year(1992)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_returns_correct_value
    answer = example.free_or_reduced_price_lunch_percentage_in_year(2010)
    assert_equal 0.113, answer
  end

  def test_free_or_reduced_price_lunch_percentage_raises_unknown_data_error
    example = epr.find_by_name("BOULDER VALLEY RE 2")
    assert_raises UnknownDataError do
      example.free_or_reduced_price_lunch_percentage_in_year(1995)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year_returns_correct_value
    answer = example.free_or_reduced_price_lunch_number_in_year(2010)
    assert_equal 2601, answer
  end

  def test_free_or_reduced_price_lunch_number_raises_unknown_data_error
    example = epr.find_by_name("BOULDER VALLEY RE 2")
    assert_raises UnknownDataError do
      example.free_or_reduced_price_lunch_number_in_year(1995)
    end
  end

  def test_title_i_in_year
    answer = example.title_i_in_year(2011)
    assert_equal 0.011, answer
  end

  def test_title_i_in_year_raises_error_on_invalid_year
    assert_raises UnknownDataError do
      answer = example.title_i_in_year(2010)
    end
  end

  def test_truncate_works
    sample = 0.482032
    assert_equal 0.482, example.truncate(sample)
  end

  def test_error_check_correctly_checks_error
    assert_raises UnknownDataError do
      example.error_check(:free_or_reduced_price_lunch, 1987)
    end
  end

  def test_yr_check_correctly_checks_errors
    refute example.yr_check(:free_or_reduced_price_lunch, 1987)
  end

  def test_truncate_correctly_truncates_numbers
    assert_equal 1234.567, example.truncate(1234.56789)
  end

  def test_data_input_source_correctly_identifies_source
    answer = {:median_household_income=>{[2005, 2009]=>56222.0, [2006, 2010]=>56456.0, [2008, 2012]=>58244.0, [2007, 2011]=>57685.0, [2009, 2013]=>58433.0}}
    assert_equal answer, example.data_input_source({:district=>"COLORADO", :median_household_income=>{[2005, 2009]=>56222.0, [2006, 2010]=>56456.0, [2008, 2012]=>58244.0, [2007, 2011]=>57685.0, [2009, 2013]=>58433.0}})
  end

end

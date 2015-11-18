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

  def test_can_instantiate_economic_profile_repo_object
    assert EconomicProfileRepository.new
  end

  def test_can_load_given_dataset
    assert epr.parser.csv_data
  end

  def test_epr_can_load_data_from_given_file
    assert_equal "COLORADO", epr.economic_profile[0].district
    assert_equal "ACADEMY 20", epr.economic_profile[1].district
  end

  def test_epr_creates_correct_number_of_objects_in_array
    assert_equal 181, epr.economic_profile.length
  end

  def test_epr_find_by_name_finds_object
    object = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_epr_find_by_lowercase_name_finds_object
    object = epr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_epr_find_by_name_returns_nil_if_no_object_matches
    object = epr.find_by_name("Steve Oscar Olson")
    assert_equal nil, object
  end

  def test_epr_find_by_name_returns_nil_if_given_integers
    object = epr.find_by_name(3728)
    assert_equal nil, object
  end

  def test_epr_find_by_name_returns_nil_if_given_array
    object = epr.find_by_name([3728])
    assert_equal nil, object
  end

  def test_epr_find_all_matching_names_finds_objects
    object = epr.find_all_matching("EAST")
    assert_equal "EAST GRAND 2", object[0].district
    assert_equal "EAST OTERO R-1", object[1].district
  end

  def test_epr_find_all_matching_names_finds_objects_with_lowercase
    object = epr.find_all_matching("east")
    assert_equal "EAST GRAND 2", object[0].district
    assert_equal "EAST OTERO R-1", object[1].district
  end

  def test_creates_economic_profile_obejct_for_a_district
    economic_data = {"COLORADO"=>{[2005, 2009]=>56222.0, [2006, 2010]=>56456.0, [2008, 2012]=>58244.0, [2007, 2011]=>57685.0, [2009, 2013]=>58433.0},
                     "ACADEMY 20"=>{[2005, 2009]=>85060.0, [2006, 2010]=>85450.0, [2008, 2012]=>89615.0, [2007, 2011]=>88099.0, [2009, 2013]=>89953.0}}
    object = epr.create_eps(:median_household_income, economic_data)
    assert_equal EconomicProfile, object[0].class
    assert_equal EconomicProfile, object[1].class
  end



end

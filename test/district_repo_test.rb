require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require 'pry'

class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv", :high_school_graduation => "./data/High school graduation rates.csv"},
                :economic_profile => {
                          :median_household_income => "./data/Median household income.csv",
                          :children_in_poverty => "./data/School-aged children in poverty.csv",
                          :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                        },
                :statewide_testing => {
                          :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                          :eigth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                          :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                          :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                          :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})
  end

  def test_can_instatiate_district_repo
    assert dr
  end

  def test_can_load_data_from_given_file
    assert_equal "COLORADO", dr.districts[0].name
    assert_equal "HI-PLAINS R-23", dr.districts[4].name
  end

  def test_creates_correct_number_of_objects_in_array
    assert_equal 8, dr.districts.length
  end

  def test_find_by_name_finds_object
    object = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", object.name
  end


  def test_find_by_lowercase_name_finds_object
    object = dr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", object.name
  end

  def test_find_by_name_returns_nil_if_no_object_matches
    object = dr.find_by_name("Steve Oscar Olson")
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_integers
    object = dr.find_by_name(3728)
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_array
    object = dr.find_by_name([3728])
    assert_equal nil, object
  end

  def test_find_all_matching_names_finds_objects
    object = dr.find_all_matching("ADAMS COUNTY")
    assert_equal "ADAMS COUNTY 14", object[0].name
    assert_equal "ADAMS COUNTY 15", object[1].name
  end

  def test_find_all_matching_names_finds_objects_with_lowercase
    object = dr.find_all_matching("adams county")
    assert_equal "ADAMS COUNTY 14", object[0].name
    assert_equal "ADAMS COUNTY 15", object[1].name
  end

  def test_can_link_district_objects_to_newly_created_enrollment_objects
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.enrollment.district
  end

  def test_can_link_district_objects_to_newly_created_economic_profile_objects
    district = dr.find_by_name("ACADEMY 20")
    binding.pry
    assert_equal "ACADEMY 20", district.economic_profile.district
  end

  def test_can_handle_full_dataset_and_create_necessary_objects
    dr.load_data({:enrollment => {:kindergarten => "./data/kindergartners in full-day program.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.enrollment.district

    answer = {:kindergarten=>{2007=>0.39465, 2006=>0.33677, 2005=>0.27807, 2004=>0.24014, 2008=>0.5357, 2009=>0.598, 2010=>0.64019, 2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}}
    district = dr.find_by_name("COLORADO")
    assert_equal answer, district.enrollment.enrollment_data
  end

  def test_can_load_high_school_data
    dr.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.enrollment.district
  end

  def test_can_load_two_data_sets_of_different_classes
    dr.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}, :statewide_testing => {:third_grade => "./test/fixtures/sample_3rd_grade_data.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.enrollment.district
  end

  def test_can_load_all_releveant_data_files_intergration_test
    dr.load_data({:enrollment => {:high_school_graduation => "./data/High school graduation rates.csv", :kindergarten => "./data/kindergartners in full-day program.csv"},
    :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eigth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})
    assert_equal 181, dr.districts.count
    assert_equal "YUMA SCHOOL DISTRICT 1", dr.districts.last.name
  end

end

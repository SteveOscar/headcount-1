require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require 'pry'
require './lib/district'

class EnrollmentRepoTest < Minitest::Test

  attr_reader :er
  def setup
    @er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
  end

  def test_can_instatiate_district_repo
    assert er
  end

  def test_can_load_data_from_given_file
    assert_equal "COLORADO", er.enrollment[0].district
    assert_equal "HI-PLAINS R-23", er.enrollment[4].district
  end

  def test_creates_correct_number_of_objects_in_array
    assert_equal 8, er.enrollment.length
  end

  def test_find_by_name_finds_object
    object = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", object.district
  end


  def test_find_by_lowercase_name_finds_object
    object = er.find_by_name("academy 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_find_by_name_returns_nil_if_no_object_matches
    object = er.find_by_name("Steve Oscar Olson")
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_integers
    object = er.find_by_name(3728)
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_array
    object = er.find_by_name([3728])
    assert_equal nil, object
  end

  def test_find_all_matching_names_finds_objects
    object = er.find_all_matching("ADAMS COUNTY")
    assert_equal "ADAMS COUNTY 14", object[0].district
    assert_equal "ADAMS COUNTY 15", object[1].district
  end

  def test_find_all_matching_names_finds_objects_with_lowercase
    object = er.find_all_matching("adams county")
    assert_equal "ADAMS COUNTY 14", object[0].district
    assert_equal "ADAMS COUNTY 15", object[1].district
  end

  def test_can_take_in_multiple_data_sets
    assert er.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
  end

  def test_can_take_in_multiple_data_sets_and_store_all
    er.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
    object = er.find_by_name("COLORADO")
    assert_equal 0.74118, object.enrollment_data[:kindergarten][2014]
    assert_equal 0.773, object.enrollment_data[:high_school_graduation][2014]
  end

end

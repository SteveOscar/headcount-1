require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repo'
require 'pry'
require './lib/district'

class EnrollmentRepoTest < Minitest::Test

  def test_can_instatiate_district_repo
    er = EnrollmentRepo.new
    assert er
  end

  def test_can_load_data_from_given_file
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    assert_equal "COLORADO", er.enrollment[0].district
    assert_equal "HI-PLAINS R-23", er.enrollment[4].district
  end

  def test_creates_correct_number_of_objects_in_array
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    assert_equal 8, er.enrollment.length
  end

  def test_find_by_name_finds_object
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", object.district
  end


  def test_find_by_lowercase_name_finds_object
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_by_name("academy 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_find_by_name_returns_nil_if_no_object_matches
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_by_name("Steve Oscar Olson")
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_integers
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_by_name(3728)
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_array
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_by_name([3728])
    assert_equal nil, object
  end

  def test_find_all_matching_names_finds_objects
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_all_matching("ADAMS COUNTY")
    assert_equal "ADAMS COUNTY 14", object[0].district
    assert_equal "ADAMS COUNTY 15", object[1].district
  end

  def test_find_all_matching_names_finds_objects_with_lowercase
    er = EnrollmentRepo.new
    er.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = er.find_all_matching("adams county")
    assert_equal "ADAMS COUNTY 14", object[0].district
    assert_equal "ADAMS COUNTY 15", object[1].district
  end


end

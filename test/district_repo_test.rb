require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repo'
require 'pry'

class DistrictRepoTest < Minitest::Test

  def test_can_instatiate_district_repo
    dr = DistrictRepo.new

    assert dr
  end

  def test_can_load_data_from_given_file
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    assert_equal "COLORADO", dr.districts[0].district
    assert_equal "HI-PLAINS R-23", dr.districts[4].district
  end

  def test_creates_correct_number_of_objects_in_array
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    assert_equal 8, dr.districts.length
  end

  def test_find_by_name_finds_object
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", object.district
  end


  def test_find_by_lowercase_name_finds_object
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_find_by_name_returns_nil_if_no_object_matches
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_by_name("Steve Oscar Olson")
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_integers
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_by_name(3728)
    assert_equal nil, object
  end

  def test_find_by_name_returns_nil_if_given_array
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_by_name([3728])
    assert_equal nil, object
  end

  def test_find_all_matching_names_finds_objects
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_all_matching("ADAMS COUNTY")
    assert_equal "ADAMS COUNTY 14", object[0].district
    assert_equal "ADAMS COUNTY 15", object[1].district
  end

  def test_find_all_matching_names_finds_objects_with_lowercase
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    object = dr.find_all_matching("adams county")
    assert_equal "ADAMS COUNTY 14", object[0].district
    assert_equal "ADAMS COUNTY 15", object[1].district
  end

  def test_can_link_district_objects_to_newly_created_enrollment_objects
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.enrollment.district
  end

  def test_can_handle_full_dataset_and_create_necessary_objects
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./data/kindergartners in full-day program.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.enrollment.district

    answer = {"2014"=>"0.74118"}
    district = dr.find_by_name("COLORADO")
    assert_equal answer, district.enrollment.enrollment_data
  end
end

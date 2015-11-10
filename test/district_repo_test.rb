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
    assert_equal "COLORADO", dr.districts[0].name
    assert_equal "HI-PLAINS R-23", dr.districts[4].name
  end

  def test_creates_correct_number_of_objects_in_array
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data.csv"}})
    assert_equal 8, dr.districts.length
  end







end

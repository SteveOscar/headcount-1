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
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    binding.pry
    assert_equal ########
  end







end

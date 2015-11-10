require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repo'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_can_create_HA_instance
    assert HeadcountAnalyst.new
  end

  def test_can_take_district_repo_as_initialized_argument
    dr = DistrictRepo.new
    ha = HeadcountAnalyst.new(dr)
    assert_equal dr, ha.dr
  end

  def test_kindergarten_participation_rate_variation_exists
    dr = DistrictRepo.new
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_returns_correct_percentage_data
    dr = DistrictRepo.new
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data_expanded.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

end

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repo'
require 'pry'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :ha
  def setup
    @dr = DistrictRepo.new
    @ha = HeadcountAnalyst.new(dr)
    dr.load_data({:enrollment => {:kindergarten => "./test/fixtures/sample_kindergarten_data_expanded.csv", :high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
  end

  def test_can_create_HA_instance
    assert HeadcountAnalyst.new
  end

  def test_can_take_district_repo_as_initialized_argument
    assert_equal dr, ha.dr
  end

  def test_kindergarten_participation_rate_variation_exists
    assert ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_against_state_returns_correct_percentage_data
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_against_county_returns_correct_percentage_data
    assert_equal 0.573, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  end

  def test_kindergarten_participation_rate_variation_trend_exists
    assert ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_trend_with_state
    answer = {"2007"=>0.992, "2006"=>1.05, "2005"=>0.961, "2004"=>1.258, "2008"=>0.718, "2009"=>0.652, "2010"=>0.681, "2011"=>0.728, "2012"=>0.689, "2013"=>0.694, "2014"=>0.661}
    assert_equal answer, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_trend_with_district
    answer = {"2007"=>1.278, "2006"=>1.206, "2005"=>0.89, "2004"=>1.325, "2008"=>0.571, "2009"=>0.39, "2010"=>0.436, "2011"=>0.489, "2012"=>0.479, "2013"=>0.489, "2014"=>0.49}
    assert_equal answer, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  end

  def test_kindergarten_participation_against_high_school_graduation_exists
    ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
    binding.pry
    assert_equal 0.647, ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
  end

  def test_kindergarten_participation_against_high_school_graduation
    skip
    assert ha.kindergarten_participation_against_high_school_graduation("blah")
  end

  # def test_kindergarten_participation_correlates_with_high_school_graduation_exists
  #
  #   assert_equal 0.394 ha.kindergarten_participation_correlates_with_high_school_graduation
  # end
end

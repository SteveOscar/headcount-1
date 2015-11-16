require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :ha
  def setup
    @dr = DistrictRepository.new
    @ha = HeadcountAnalyst.new(dr)
    dr.load_data({
                    :enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv",
                    },
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eigth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
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

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_exists
    assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")
  end

  def test_kindergarten_correlates_high_school_against_state
    answer = ha.kindergarten_participation_correlates_with_high_school_graduation(:for => "COLORADO")
    assert_equal true, answer
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_across_mulitple_districts
    answer = ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'ADAMS COUNTY 14'])
    refute answer
  end

  def test_district_change
    answer = ha.district_change(:third_grade, :math, "ACADEMY 20")
    assert_equal -0.004, answer
  end

  def test_district_change_results_for_all_districts
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ["SPRINGFIELD RE-4", 0.149], result
  end

  def test_district_change_results_for_all_districts_top_3
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    assert_equal 3, result.size
    assert_equal [["SPRINGFIELD RE-4", 0.149], ["WESTMINSTER 50", 0.1], ["CENTENNIAL R-1", 0.088]], result
  end

  def test_can_get_districts_list_with_averaged_growth_per_subject
    result = ha.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_format_argument_to_proper_format_for_grade
    result1 = ha.format_grade_argument(3)
    result2 = ha.format_grade_argument(8)
    assert_equal :third_grade, result1
    assert_equal :eigth_grade, result2
  end

  def test_formatted_arguments_work_in_top_statewide_method
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ["SPRINGFIELD RE-4", 0.149], result
  end

  def test_statewide_test_year_over_year_top_3_integration
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    answer = [["SPRINGFIELD RE-4", 0.149], ["WESTMINSTER 50", 0.1], ["CENTENNIAL R-1", 0.088]] #confirm data
    assert_equal answer, result
  end

  def test_raises_error_if_no_grade_is_provided
    e = assert_raises InsufficientInformationError do
      ha.top_statewide_test_year_over_year_growth(top: 3, subject: :math)
    end

    assert_equal "A grade must be provided to answer this question", e.message
  end

  def test_raises_error_if_unknown_grade_is_provided
    e = assert_raises UnknownDataError do
      ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
    end
    assert_equal "9 is not a known grade", e.message
  end

end

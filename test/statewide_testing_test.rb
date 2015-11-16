require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_testing'
require './lib/statewide_testing_repository'
require 'pry'

class StatewideTestingTest < Minitest::Test
  attr_reader :sw, :data, :found

  def setup
    @data = {"COLORADO"=>
            {"2008"=>{"Math"=>"0.697", "Reading"=>"0.703", "Writing"=>"0.501"},
             "2009"=>{"Math"=>"0.691", "Reading"=>"0.726", "Writing"=>"0.536"},
             "2010"=>{"Math"=>"0.706", "Reading"=>"0.698", "Writing"=>"0.504"},
             "2011"=>{"Math"=>"0.696", "Reading"=>"0.728", "Writing"=>"0.513"},
             "2012"=>{"Reading"=>"0.739", "Math"=>"0.71", "Writing"=>"0.525"},
             "2013"=>{"Math"=>"0.72295", "Reading"=>"0.73256", "Writing"=>"0.50947"},
             "2014"=>{"Math"=>"0.71589", "Reading"=>"0.71581", "Writing"=>"0.51072"}}}
    @sw = StatewideTesting.new(data)
    @swtr = StatewideTestingRepository.new
    @swtr.load_data(:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv", :eigth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./test/fixtures/sample_proficiency_CSAP_.csv", :reading => "./test/fixtures/sample_proficiency_reading.csv", :writing => "./test/fixtures/sample_proficiency_writing.csv"})
    @found = @swtr.find_by_name("COLORADO")
  end

  def test_statewide_testing_exists
    assert StatewideTesting.new(data)
  end

  def test_can_initialize_Statewide_testing_object
    assert_equal sw.class, StatewideTesting
  end

  def test_proficient_by_grade_returns_a_hash
    result = found.proficient_by_grade(3)
    assert_equal Hash, result.class
  end

  def test_proficient_by_grade_returns_correct_data
    result = found.proficient_by_grade(3)
    assert_equal data["COLORADO"], result
  end

  def test_proficient_by_grade_8_returns_correct_data
    result = found.proficient_by_grade(8)
    answer = {"2008"=>{"Math"=>"0.469", "Reading"=>"0.703", "Writing"=>"0.529"},
             "2009"=>{"Math"=>"0.499", "Reading"=>"0.726", "Writing"=>"0.528"},
             "2010"=>{"Math"=>"0.51", "Reading"=>"0.679", "Writing"=>"0.549"},
             "2011"=>{"Reading"=>"0.67", "Math"=>"0.513", "Writing"=>"0.543"},
             "2012"=>{"Math"=>"0.515", "Writing"=>"0.548", "Reading"=>"0.671"},
             "2013"=>{"Math"=>"0.51482", "Reading"=>"0.66888", "Writing"=>"0.55788"},
             "2014"=>{"Math"=>"0.52385", "Reading"=>"0.66351", "Writing"=>"0.56183"}}
    assert_equal answer, result
  end

  def test_proficient_by_race_or_ethnicity_method
    result = found.proficient_by_race_or_ethnicity(:hispanic)
    assert result
  end

  def test_proficient_by_race_or_ethnicity_with_hispanic
    result = found.proficient_by_race_or_ethnicity(:hispanic)
    data = ["2011", {:math=>0.393, :reading=>0.498, :writing=>0.368}]
    assert_equal data, result.first
  end

  def test_proficient_by_race_or_ethnicity_with_white
    result = found.proficient_by_race_or_ethnicity(:white)
    data = ["2011", {:math=>0.659, :reading=>0.789, :writing=>0.663}]
    assert_equal data, result.first
  end

  def test_proficient_by_race_or_ethnicity_returns_all_three_subjects_for_white
    result = found.proficient_by_race_or_ethnicity(:white)
    assert_equal 3, result.first[1].length
  end

  def test_proficient_by_race_or_ethnicity_returns_all_three_subjects_for_asian
    result = found.proficient_by_race_or_ethnicity(:asian)
    assert_equal 3, result.first[1].length
  end

  def test_proficient_by_grade_raises_an_error_with_unknown_grade_argument
    assert_raises UnknownDataError do
      found.proficient_by_grade(4)
    end
  end

  def test_proficient_by_grade_raises_an_error_with_nil_argument
    assert_raises UnknownDataError do
      found.proficient_by_grade(nil)
    end
  end

  def test_proficient_by_race_raises_an_error_with_unknown_grade_argument
    assert_raises UnknownRaceError do
      found.proficient_by_race_or_ethnicity(:yellow)
    end
  end

  def test_proficient_for_subject_by_grade_in_year_exists
    assert found.proficient_for_subject_by_grade_in_year(:math, 3, 2012)
  end

  def test_proficient_for_subject_by_grade_in_year_returns_correct_data
    answer = found.proficient_for_subject_by_grade_in_year(:reading, 3, 2012)
    assert_equal 0.739, answer
    answer = found.proficient_for_subject_by_grade_in_year(:math, 8, 2009)
    assert_equal 0.499, answer
  end

  def test_proficient_for_subject_by_grade_in_year_raises_error_for_subject
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_grade_in_year(:science, 3, 2012)
    end
  end

  def test_proficient_for_subject_by_grade_in_year_raises_error_for_year
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_grade_in_year(:math, 3, 2006)
    end
  end

  def test_proficient_for_subject_by_grade_in_year_raises_error_for_grade
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_grade_in_year(:math, 1, 2011)
    end
  end

  def test_proficient_for_subject_by_race_in_year_yields_correct_data
    assert_equal 0.659, found.proficient_for_subject_by_race_in_year(:math, :white, 2011)
  end

  def test_proficient_for_subject_by_race_in_year_recognizes_wrong_data_race_input
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_race_in_year(:math, :yellow, 2011)
    end
  end

  def test_proficient_for_subject_by_race_in_year_recognizes_wrong_data_year_input
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_race_in_year(:math, :yellow, 1776)
    end
  end

  def test_proficient_for_subject_by_race_in_year_recognizes_wrong_data_subject_input
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_race_in_year(:science, :yellow, 1776)
    end
  end

  def test_proficient_for_subject_by_race_in_year_recognizes_wrong_data_year_string_input
    assert_raises UnknownDataError do
      found.proficient_for_subject_by_race_in_year(:math, :white, "2011")
    end
  end

end

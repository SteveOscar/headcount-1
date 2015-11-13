require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_testing'
require './lib/statewide_testing_repo'
require 'pry'

class StatewideTestingTest < Minitest::Test
  attr_reader :sw, :data

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
    @swtr = StatewideTestingRepo.new
    @swtr.load_data(:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv", :eigth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./test/fixtures/sample_proficiency_CSAP_.csv", :reading => "./test/fixtures/sample_proficiency_reading.csv", :writing => "./test/fixtures/sample_proficiency_writing.csv"})
  end

  def test_statewide_testing_exists
    assert StatewideTesting.new(data)
  end

  def test_can_initialize_Statewide_testing_object
    assert_equal sw.class, StatewideTesting
  end

  def test_proficient_by_grade_returns_a_hash
    found = @swtr.find_by_name("COLORADO")
    result = found.proficient_by_grade(3)
    assert_equal Hash, result.class
  end

  def test_proficient_by_grade_returns_correct_data
    found = @swtr.find_by_name("COLORADO")
    result = found.proficient_by_grade(3)
    assert_equal data["COLORADO"], result
  end

  def test_proficient_by_grade_8_returns_correct_data
    found = @swtr.find_by_name("COLORADO")
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
    found = @swtr.find_by_name("COLORADO")
    result = found.proficient_by_race_or_ethnicity(:hispanic)
    assert result
  end

  def test_proficient_by_race_or_ethnicity_with_hispanic
    found = @swtr.find_by_name("COLORADO")
    result = found.proficient_by_race_or_ethnicity(:hispanic)
    data = ["2011", {:math=>0.393, :reading=>0.498, :writing=>0.368}]
    assert_equal data, result.first
  end

  def test_proficient_by_race_or_ethnicity_with_white
    found = @swtr.find_by_name("COLORADO")
    result = found.proficient_by_race_or_ethnicity(:white)
    data = ["2011", {:math=>0.659, :reading=>0.789, :writing=>0.663}]
    assert_equal data, result.first
  end

  def test_proficient_by_race_or_ethnicity_returns_all_three_subjects
    found = @swtr.find_by_name("COLORADO")
    result = found.proficient_by_race_or_ethnicity(:white)
    assert_equal 3, result.first[1].length
  end



end

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'
require 'pry'

class StateWideTestRepoTest < Minitest::Test

  attr_reader :swtr

  def setup
    @swtr = StatewideTestRepository.new
    @swtr.load_data({:statewide_testing => {
            :third_grade => "./test/fixtures/sample_3rd_grade_data.csv"}})
  end

  def test_can_instantiate_statewide_testing_repo_object
    assert StatewideTestRepository.new
  end

  def test_can_load_given_dataset
    assert swtr.parser.csv_data
  end

  def test_swtr_can_load_data_from_given_file
    assert_equal "COLORADO", swtr.statewide_test[0].district
    assert_equal "ACADEMY 20", swtr.statewide_test[1].district
  end

  def test_swtr_creates_correct_number_of_objects_in_array
    assert_equal 14, swtr.statewide_test.length
  end

  def test_swtr_find_by_name_finds_object
    object = swtr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_swtr_find_by_lowercase_name_finds_object
    object = swtr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", object.district
  end

  def test_swtr_find_by_name_returns_nil_if_no_object_matches
    object = swtr.find_by_name("Steve Oscar Olson")
    assert_equal nil, object
  end

  def test_swtr_find_by_name_returns_nil_if_given_hash
    object = swtr.find_by_name(sample: "data")
    assert_equal nil, object
  end

  def test_swtr_find_by_name_returns_nil_if_given_float
    object = swtr.find_by_name(3.456)
    assert_equal nil, object
  end

  def test_swtr_find_by_name_returns_nil_if_given_symbol
    object = swtr.find_by_name(:what)
    assert_equal nil, object
  end

  def test_swtr_find_by_name_returns_nil_if_given_integers
    object = swtr.find_by_name(3728)
    assert_equal nil, object
  end

  def test_swtr_find_by_name_returns_nil_if_given_array
    object = swtr.find_by_name([3728])
    assert_equal nil, object
  end

  def test_swtr_find_all_matching_names_finds_objects
    object = swtr.find_all_matching("EAST")
    assert_equal "EAST GRAND 2", object[0].district
    assert_equal "EAST OTERO R-1", object[1].district
  end

  def test_swtr_find_all_matching_names_finds_objects_with_lowercase
    object = swtr.find_all_matching("east")
    assert_equal "EAST GRAND 2", object[0].district
    assert_equal "EAST OTERO R-1", object[1].district
  end

  def test_can_append_enrollment_data_to_existing_enrollment_object
    found = swtr.find_by_name("ACADEMY 20")
    assert_equal :third_grade, found.test_data.keys[0]
    refute_equal :eigth_grade, found.test_data.keys[1]
    swtr.load_data(:statewide_testing => {:eigth_grade => "./test/fixtures/sample_8th_grade_data.csv"})
    assert_equal :eigth_grade, found.test_data.keys[1]
  end

end

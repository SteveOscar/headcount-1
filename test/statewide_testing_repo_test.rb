require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_testing_repository'
require 'pry'

class StateWideTestingRepoTest < Minitest::Test

  attr_reader :swtr

  def setup
    @swtr = StatewideTestingRepository.new
    @swtr.load_data({:statewide_testing => {
            :third_grade => "./test/fixtures/sample_3rd_grade_data.csv"}})
  end

  def test_can_instantiate_statewide_testing_repo_object
    assert StatewideTestingRepository.new
  end

  def test_can_load_given_dataset
    assert swtr.parser.csv_data
  end

  def test_swtr_can_load_data_from_given_file
    assert_equal "COLORADO", swtr.statewide_testing[0].district
    assert_equal "ACADEMY 20", swtr.statewide_testing[1].district
  end

  def test_swtr_creates_correct_number_of_objects_in_array
    assert_equal 14, swtr.statewide_testing.length
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

  # def test_can_take_in_multiple_data_sets_and_store_all
  #   er.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
  #   object = er.find_by_name("COLORADO")
  #   assert_equal "0.74118", object.enrollment_data[:kindergarten]["2014"]
  #   assert_equal "0.773", object.enrollment_data[:high_school_graduation]["2014"]
  # end


end

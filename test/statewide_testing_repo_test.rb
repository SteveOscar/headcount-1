require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_testing_repo'
require 'pry'

class StateWideTestingRepoTest < Minitest::Test

  attr_reader :swtr

  def setup
    @swtr = StatewideTestingRepo.new
  end

  def test_can_instantiate_statewide_testing_repo_object
    assert StatewideTestingRepo.new
  end

  def test_can_load_given_dataset
    @swtr.load_data({:statewide_testing => {
            :third_grade => "./test/fixtures/sample_3rd_grade_data.csv"}})

    assert swtr.parser.csv_data
  end

  








end

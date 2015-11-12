require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_testing'
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
  end

  def test_statewide_testing_exists
    assert StatewideTesting.new(data)
  end

  def test_can_initialize_Statewide_testing_object
    assert_equal sw.class, StatewideTesting
  end

  # def test_can_initialize_with_
  #
  # end

end

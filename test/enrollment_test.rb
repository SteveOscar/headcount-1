require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'
require 'pry'

class EnrollmentTest < Minitest::Test
  attr_reader :e

  def setup
    @e = Enrollment.new({:district => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end

  def test_can_instantiate_district
    assert e
  end

  def test_can_initialize_with_data
    data = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677}
    assert_equal data, e.enrollment_data
  end

  def test_can_initialize_with_name
    assert_equal "ACADEMY 20", e.district
  end

  def test_kindergarten_participation_by_year_returns_hash
    assert_equal "Hash", e.kindergarten_participation_by_year.class.to_s
  end

  def test_kindergarten_participation_by_year_returns_correct_data
    result = e.kindergarten_participation_by_year
    data = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677}
    assert_equal data, result
  end

  def test_kindergarten_participation_in_year_truncates_to_three_digits
    result = e.kindergarten_participation_in_year(2011)
    assert_equal 0.354, result
  end



end

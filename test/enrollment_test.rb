require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'
require './lib/enrollment_repository'
require 'pry'

class EnrollmentTest < Minitest::Test
  attr_reader :e, :er

  def setup
    @er = EnrollmentRepository.new
    @e = Enrollment.new({:district => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end

  def test_can_instantiate_district
    assert e
  end

  def test_can_initialize_with_data
    data = {:kindergarten=>{2010=>0.3915, 2011=>0.35356, 2012=>0.2677}}
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
    data = {:kindergarten=>{2010=>0.3915, 2011=>0.35356, 2012=>0.2677}}
    assert_equal data, result
  end

  def test_kindergarten_participation_in_year_truncates_to_three_digits
    result = e.kindergarten_participation_in_year(2011)
    assert_equal 0.353, result
  end

  def test_graduation_rate_by_year_method_works
    er.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
    e = er.find_by_name("COLORADO")
    result = {2011=>0.739, 2012=>0.753, 2013=>0.769, 2014=>0.773}
    assert_equal result, e.graduation_rate_by_year
  end

  def test_graduation_rate_in_year_method_works
    er.load_data({:enrollment => {:high_school_graduation => "./test/fixtures/sample_hs_graduation_data.csv"}})
    e = er.find_by_name("COLORADO")
    result = 0.769
    assert_equal result, e.graduation_rate_in_year(2013)
  end


end

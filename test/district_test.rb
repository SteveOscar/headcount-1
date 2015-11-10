require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require 'pry'

class DistrictTest < Minitest::Test

  def test_can_instantiate_district
    d = District.new({name: "ACADEMY 20"})
    assert d
  end

  def test_can_initialize_with_name
    d = District.new({name: "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end

end

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/csv_parser_0'
require 'pry'

class ParserTest < Minitest::Test
  attr_reader :csv, :parser, :path, :test_parser, :test_path

  def setup
    @csv = CSV.open("./test/fixtures/sample_kindergarten_data.csv", {:headers => true, header_converters: :symbol})
    @parser = CSVParser.new
    @test_parser = TestingParser.new
    @test_path = test_parser.load_data('./test/fixtures/sample_3rd_grade_data.csv')
    @path = parser.load_data('./test/fixtures/sample_kindergarten_data.csv')
  end

  def test_can_create_parser_object
    assert parser
  end

  def test_parser_generates_csv_object
    loaded = path
    assert_equal 'CSV', loaded.class.to_s
  end

  def test_can_load_data_set
    loaded = path
    assert loaded
  end

  def test_can_parse_districts
    data = path
    districts = parser.get_districts
    assert_equal "ACADEMY 20", districts[1]
  end

  def test_can_parse_districts_and_remove_duplicates
    districts = parser.get_districts
    assert_equal 8, districts.length
  end

  def test_get_enrollment_creates_a_hash
    enrollment = parser.get_enrollment
    assert_equal "Hash", enrollment.class.to_s
  end

  def test_get_enrollment_creates_a_hash_and_updates_already_existing_district
    enrollment = parser.get_enrollment
    answer = {"2010"=>"1", "2011"=>"1"}
    assert_equal answer, enrollment["ADAMS COUNTY 14"]
  end

  def test_can_initialize_testing_parser
    data = test_parser.get_testing_data
    assert data
  end

  def test_test_parser_can_load_statewide_testing_data_and_parse_correctly
    data = test_parser.get_testing_data
    answer = {"Math"=>"0.696", "Reading"=>"0.728", "Writing"=>"0.513"}
    assert_equal answer, data["COLORADO"]["2011"]
  end

  def test_test_parser_can_load_statewide_data_and_pull_out_specific_data
    data = test_parser.get_testing_data
    answer = "0.54"
    assert_equal answer, data["ADAMS COUNTY 14"]["2012"]["Reading"]
  end

  def test_test_parser_can_load_multiple_districts
    data = test_parser.get_testing_data
    assert_equal 14, data.count
  end

  def test_test_parser_doesnt_find_non_existant_data
    data = test_parser.get_testing_data
    refute data["GREG"]
  end

  def test_test_parser_correctly_elminates_duplicates
    data = test_parser.get_testing_data
    assert data.keys == data.keys.uniq
  end

end

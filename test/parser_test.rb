require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/csv_parser_0'
require 'pry'

class ParserTest < Minitest::Test
  attr_reader :csv, :parser

  def setup
    @csv = CSV.open("./test/fixtures/sample_kindergarten_data.csv", {:headers => true, header_converters: :symbol})
    @parser = CSVParser.new
  end

  def test_can_create_parser_object
    assert parser
  end

  def test_parser_generates_csv_object
    loaded = parser.load_data('./test/fixtures/sample_kindergarten_data.csv')
    assert_equal 'CSV', loaded.class.to_s
  end

  def test_can_load_data_set
    loaded = parser.load_data('./test/fixtures/sample_kindergarten_data.csv')
    assert loaded
  end

  def test_can_parse_districts
    data = parser.load_data('./test/fixtures/sample_kindergarten_data.csv')
    districts = parser.get_districts
    assert_equal "ACADEMY 20", districts[1]
  end

  def test_can_parse_districts_and_remove_duplicates
    parser.load_data('./test/fixtures/sample_kindergarten_data.csv')
    districts = parser.get_districts
    assert_equal 8, districts.length
  end









end

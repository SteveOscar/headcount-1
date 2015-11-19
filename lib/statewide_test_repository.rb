require 'pry'
require_relative 'statewide_test'
require_relative 'csv_parser'

class StatewideTestRepository
  attr_reader :parser
  attr_accessor :statewide_test, :districts

  def initialize
    @parser = TestingParser.new
  end

  def load_data(given_data)
    given_data[:statewide_testing].each do |grade, percentages_data|
      parser.load_data(percentages_data)
      check_for_existing_objects(grade)
    end
  end

  def check_for_existing_objects(grade)
    if statewide_test.nil?
      create_statewide_testing_objects(grade, parser.get_testing_data)
    else
      append_statewide_testing(grade, parser.get_testing_data)
    end
  end

  def create_statewide_testing_objects(grade, hash)
    @statewide_test = hash.map do |name, statewide_testing|
      StatewideTest.new({district: name, grade => statewide_testing})
    end
  end

  def append_statewide_testing(grade, hash)
    statewide_test.each do |object|
      object.test_data.merge!({ grade => (hash.select { |k,v| k == object.district }).values[0]})
    end
  end

  def find_by_name(string)
    statewide_test.find {|object| object.district == string.to_s.upcase}
  end

  def find_all_matching(string)
    statewide_test.find_all {|object| object.district.include?(string.upcase)}
  end

end

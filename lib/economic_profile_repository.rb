require 'pry'
require_relative 'economic_profile'
require_relative 'csv_parser_0'

class EconomicProfileRepository
  attr_reader :parser, :test_parser, :economic_parser
  attr_accessor :economic_profile, :districts

  def initialize
    @parser = CSVParser.new
    @test_parser = TestingParser.new
    @economic_parser = EconomicParser.new
  end

  def load_data(given_data)
    given_data[:economic_profile].each do |data_type, percentages_data|
      economic_parser.load_data(percentages_data) if data_type.to_s.include?("income")
      test_parser.load_data(percentages_data) if data_type.to_s.include?("lunch")
      parser.load_data(percentages_data) unless data_type.to_s.include?("lunch")
      check_for_existing_objects(data_type)
    end
  end

  def check_for_existing_objects(data_type)
    if economic_profile.nil?
      create_economic_profile_objects(data_type, test_parser.get_testing_data) if data_type.to_s.include?("lunch")
      create_economic_profile_objects(data_type, economic_parser.get_income_data) if data_type.to_s.include?("income")
      create_economic_profile_objects(data_type, parser.get_enrollment) unless data_type.to_s.include?("lunch") || data_type.to_s.include?("income")
    else
      append_economic_profile(data_type, test_parser.get_testing_data) if data_type.to_s.include?("lunch")
      create_economic_profile_objects(data_type, economic_parser.get_income_data) if data_type.to_s.include?("income")
      append_economic_profile(data_type, parser.get_enrollment) unless data_type.to_s.include?("lunch") || data_type.to_s.include?("income")
    end
  end

  def create_economic_profile_objects(data_type, economic_data)
    @economic_profile = economic_data.map do |name, economic_profile|
      EconomicProfile.new({district: name, data_type => economic_profile})
    end
    economic_profile
  end

  def append_economic_profile(grade, economic_data)
    economic_profile.each do |object|
      object.economic_data.merge!({ grade => (economic_data.select { |k,v| k == object.district }).values[0]})
    end
  end

  def find_by_name(string)
    economic_profile.find {|object| object.district == string.to_s.upcase}
  end

  def find_all_matching(string)
    economic_profile.find_all {|object| object.district.include?(string.upcase)}
  end

end

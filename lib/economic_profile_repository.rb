require 'pry'
require_relative 'economic_profile'
require_relative 'csv_parser_0'

class EconomicProfileRepository
  attr_reader :parser, :test_parser, :ec_parser
  attr_accessor :economic_profile, :districts

  def initialize
    @parser = CSVParser.new
    @test_parser = TestingParser.new
    @ec_parser = EconomicParser.new
  end

  def load_data(given_data)
    given_data[:economic_profile].each do |data_type, percentages_data|
      ec_parser.load_data(percentages_data) if data_type.to_s.include?("income")
      ec_parser.load_data(percentages_data) if data_type.to_s.include?("lunch")
      parser.load_data(percentages_data) unless data_type.to_s.include?("lunch")
      check_for_existing_objects(data_type)
    end
  end

  def check_for_existing_objects(data_type)
    if economic_profile.nil?
      create_eps(data_type, ec_parser.get_lunch_data) if data_type.to_s.include?("lunch")
      create_eps(data_type, ec_parser.get_income_data) if data_type.to_s.include?("income")
      create_eps(data_type, parser.get_enrollment) unless data_type.to_s.include?("lunch") || data_type.to_s.include?("income")
    else
      append_eps(data_type, ec_parser.get_lunch_data) if data_type.to_s.include?("lunch")
      create_eps(data_type, ec_parser.get_income_data) if data_type.to_s.include?("income")
      append_eps(data_type, parser.get_enrollment) unless data_type.to_s.include?("lunch") || data_type.to_s.include?("income")
    end
  end

  def create_eps(data_type, economic_data)
    @economic_profile = economic_data.map do |name, economic_profile|

        EconomicProfile.new({district: name, data_type => economic_profile})

    end
    economic_profile
  end

  def append_eps(grade, economic_data)
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

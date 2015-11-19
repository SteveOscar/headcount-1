require 'pry'
require_relative 'economic_profile'
require_relative 'csv_parser'
require_relative 'testing_parser'
require_relative 'economic_parser'

class EconomicProfileRepository
  attr_reader :parser, :test_parser, :ec_parser
  attr_accessor :economic_profile, :districts

  def initialize
    @parser = BasicParser.new
    @test_parser = TestingParser.new
    @ec_parser = EconomicParser.new
  end

  def load_data(given_data)
    given_data[:economic_profile].each do |type, percentages_data|
      ec_parser.load_data(percentages_data) if is?(type, "income")
      ec_parser.load_data(percentages_data) if is?(type, "lunch")
      parser.load_data(percentages_data) unless is?(type, "lunch")
      check_for_existing_objects(type)
    end
  end

  def check_for_existing_objects(data_type)
    if economic_profile.nil?
      determine_type_and_create_economic_profile(data_type)
    else
      append_data_to_corrent_type(data_type)
    end
  end

  def determine_type_and_create_economic_profile(type)
    create_eps(type, ec_parser.get_lunch_data) if is?(type, "lunch")
    create_eps(type, ec_parser.get_income_data) if is?(type, "income")
    create_eps(type, parser.get_enrollment) unless is?(type, "lunch") || is?(type, "income")
  end

  def append_data_to_corrent_type(type)
    append_eps(type, ec_parser.get_lunch_data) if is?(type, "lunch")
    create_eps(type, ec_parser.get_income_data) if is?(type, "income")
    append_eps(type, parser.get_enrollment) unless is?(type, "lunch") || is?(type, "income")
  end

  def is?(data, type)
    data.to_s.include?(type)
  end

  def create_eps(data_type, economic_data)
    @economic_profile = economic_data.map do |name, economic_profile|
        EconomicProfile.new({district: name, data_type => economic_profile})
    end
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

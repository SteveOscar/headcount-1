require 'pry'
require_relative 'district'
require_relative 'csv_parser'
require_relative 'testing_parser'
require_relative 'economic_parser'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class DistrictRepository
  attr_accessor :districts, :er, :parser, :swtr, :test_parser, :epr, :economic_parser

  def initialize
    @swtr = StatewideTestRepository.new
    @er = EnrollmentRepository.new
    @epr = EconomicProfileRepository.new
    @parser = BasicParser.new
    @test_parser = TestingParser.new
    @economic_parser = EconomicParser.new
  end

  def load_data(given_data)
    parser.load_data(given_data.values.first.values[0])
    create_district_objects(parser.get_districts)
    given_data.keys.each do |key|
      load_by_type(given_data, key)
    end
  end

  def load_by_type(given_data, key)
    if key == :enrollment
      load_enrollment_data(given_data)
    elsif key == :statewide_testing
      load_statewide_testing_data(given_data)
    else
      load_economic_data(given_data)
    end
  end

  def load_enrollment_data(given_data)
    er.load_data(given_data)
    link_district_to_enrollment
  end

  def load_statewide_testing_data(given_data)
    test_parser.load_data(given_data.values.first.values[0])
    swtr.load_data(given_data)
    link_district_to_statewide_testing
  end

  def load_economic_data(given_data)
    economic_parser.load_data(given_data.values.first.values[0])
    epr.load_data(given_data)
    link_district_to_economic_profile
  end

  def link_district_to_enrollment
    districts.each do |object|
      object.enrollment = er.find_by_name(object.name)
    end
  end

  def link_district_to_statewide_testing
    districts.each do |object|
      object.statewide_test = swtr.find_by_name(object.name)
    end
  end

  def link_district_to_economic_profile
    districts.each do |object|
      object.economic_profile = epr.find_by_name(object.name)
    end
  end

  def create_district_objects(array)
    @districts = array.map do |district|
      District.new({name: district})
    end
    districts
  end

  def find_by_name(string)
    districts.find { |object| object.name == string.to_s.upcase }
  end

  def find_all_matching(string)
    districts.find_all { |object| object.name.include?(string.upcase) }
  end

end

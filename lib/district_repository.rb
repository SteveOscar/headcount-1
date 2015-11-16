require 'pry'
require_relative 'district'
require_relative 'csv_parser_0'
require_relative 'enrollment_repository'
require_relative 'statewide_testing_repository'

class DistrictRepository
  attr_accessor :districts, :er, :parser, :swtr, :test_parser

  def initialize
    @swtr = StatewideTestingRepository.new
    @er = EnrollmentRepository.new
    @parser = CSVParser.new
    @test_parser = TestingParser.new
  end

  def load_data(given_data)
    parser.load_data(given_data.values.first.values[0])
    create_district_objects(parser.get_districts)
    given_data.keys.each do |key|
      if key == :enrollment
        er.load_data(given_data)
        link_district_to_enrollment
      elsif key == :statewide_testing
        test_parser.load_data(given_data.values.first.values[0])
        swtr.load_data(given_data)
        link_district_to_statewide_testing
      end
    end
  end

  def link_district_to_enrollment
    districts.each do |object|
      object.enrollment = er.find_by_name(object.name)
    end
  end

  def link_district_to_statewide_testing
    districts.each do |object|
      object.statewide_testing = swtr.find_by_name(object.name)
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

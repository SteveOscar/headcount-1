require 'pry'
require_relative 'district'
require_relative 'csv_parser_0'
require_relative 'enrollment_repo'

class DistrictRepo
  attr_accessor :districts, :er

  def initialize
    @er = EnrollmentRepo.new
  end

  def load_data(given_data)
    path = given_data[:enrollment][:kindergarten]
    c = CSVParser.new
    c.load_data(path)
    create_district_objects(c.get_districts)
    er.load_data(given_data)
    link_district_to_enrollment
  end

  def link_district_to_enrollment
    @districts.each do |object|
      object.enrollment = @er.find_by_name(object.district)
    end
  end


  def create_district_objects(array)
    @districts = array.map do |district|
      District.new({district: district})
    end
    @districts
  end

  def find_by_name(string)
    @districts.find { |object| object.district == string.to_s.upcase }
  end

  def find_all_matching(string)
    @districts.find_all { |object| object.district.include?(string.upcase) }
  end

end

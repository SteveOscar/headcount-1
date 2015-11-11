require 'pry'
require_relative 'enrollment'
require_relative 'csv_parser_0'

class EnrollmentRepo

  attr_accessor :enrollment, :districts

  def load_data(given_data)
    path = given_data[:enrollment][:kindergarten]
    c = CSVParser.new
    c.load_data(path)
    create_enrollment_objects(c.get_enrollment)
  end

  def create_enrollment_objects(hash)
    @enrollment = hash.map do |district, enrollment|
      Enrollment.new({district: district, kindergarten_participation: enrollment})
    end
    enrollment
  end

  def find_by_name(string)
    enrollment.find { |object| object.district == string.to_s.upcase }
  end

  def find_all_matching(string)
    enrollment.find_all { |object| object.district.include?(string.upcase) }
  end

end

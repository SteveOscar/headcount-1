require 'pry'
require_relative 'enrollment'
require_relative 'csv_parser_0'

class EnrollmentRepo

  attr_accessor :enrollment, :districts

  def load_data(given_data)
    path = given_data[:enrollment][:kindergarten]
    c = CSVParser.new
    c.load_data(path)
    create_enrollment_objects(c.get_districts)
  end

  def create_enrollment_objects(array)
    @enrollment = @districts = array.map do |name|
      Enrollment.new({name: name})
    end
    @enrollment
  end

  def find_by_name(string)
    @enrollment.find { |object| object.name == string.to_s.upcase }
  end

  def find_all_matching(string)
    @enrollment.find_all { |object| object.name.include?(string.upcase) }
  end

end

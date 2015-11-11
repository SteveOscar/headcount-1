require 'pry'
require_relative 'enrollment'
require_relative 'csv_parser_0'

class EnrollmentRepo

  attr_accessor :enrollment, :districts, :c

  def initialize
    @c = CSVParser.new
  end

  def load_data(given_data)
    path = given_data[:enrollment]
    path.each do |grade, percentages_data|
      c.load_data(percentages_data)
      if @enrollment.nil?
        create_enrollment_objects(grade, c.get_enrollment)
      else
        append_data_onto_enrollment_object(grade, c.get_enrollment)
      end
    end

  end

  def create_enrollment_objects(grade, hash)
    @enrollment = hash.map do |name, enrollment|
      Enrollment.new({district: name, grade => enrollment})
    end
    enrollment
  end

  def append_data_onto_enrollment_object(grade, hash)
    @enrollment.each do |object|
      object.enrollment_data.merge!({ grade => hash.select { |k,v| k == object.district }})
    end
    binding.pry
  end

  def find_by_name(string)
    enrollment.find { |object| object.district == string.to_s.upcase }
  end

  def find_all_matching(string)
    enrollment.find_all { |object| object.district.include?(string.upcase) }
  end

end

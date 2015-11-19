require 'pry'
require_relative 'enrollment'
require_relative 'csv_parser'

class EnrollmentRepository
  attr_accessor :enrollment, :districts
  attr_reader :parser

  def initialize
    @parser = BasicParser.new
  end

  def load_data(given_data)
    given_data[:enrollment].each do |grade, percentages_data|
      parser.load_data(percentages_data)
      check_for_existing_objects(grade)
    end
  end

  def check_for_existing_objects(grade)
    if enrollment.nil?
      create_enrollment_objects(grade, parser.get_enrollment)
    else
      append_enrollment(grade, parser.get_enrollment)
    end
  end

  def create_enrollment_objects(grade, hash)
    @enrollment = hash.map do |name, enrollment|
      Enrollment.new({district: name, grade => enrollment})
    end
    enrollment
  end

  def append_enrollment(grade, hash)
    enrollment.each do |object|
      object.enrollment_data.merge!({ grade => (hash.select { |k,v| k == object.district }).values[0]})
    end
  end

  def find_by_name(string)
    enrollment.find { |object| object.district == string.to_s.upcase }
  end

  def find_all_matching(string)
    enrollment.find_all { |object| object.district.include?(string.upcase) }
  end

end

require 'pry'
require_relative 'district'
require_relative 'csv_parser_0'

class DistrictRepo

  attr_accessor :districts

  def load_data(given_data)
    path = given_data[:enrollment][:kindergarten]
    c = CSVParser.new
    c.load_data(path)
    create_district_objects(c.get_districts)
  end

  def create_district_objects(array)
    @districts = array.map do |name|
      District.new({name: name})
    end
    @districts
  end

  def find_by_name(string)
    @districts.find { |object| object.name == string.upcase }
  end

  def find_all_matching(string)
    @districts.find_all { |object| object.name.include?(string.upcase) }
  end

end

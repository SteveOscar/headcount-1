require 'pry'
require_relative 'district'
require_relative 'csv_parser_0'

class DistrictRepo

  def load_data(given_data)
    path = given_data[:enrollment][:kindergarten]
    c = CSVParser.new
    c.load_data(path)
    create_district_objects(c.get_districts)
  end

  def create_district_objects(array)
    districts = []
    array.each do |name|
      districts << District.new({name: name})
    end
    districtsq
    binding.pry
  end
end

require 'pry'
require 'csv'

class CSVParser
  attr_accessor :csv_data

  def load_data(path)
    @csv_data = CSV.open(path, {:headers => true})
  end

  def get_districts
    districts = @csv_data.readlines.map { |line| line[0].upcase }
    districts.uniq!
  end




end

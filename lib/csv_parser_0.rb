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

  def get_enrollment
    data = {}
    enrollment = @csv_data.readlines.each do |line|
      data[(line[0].upcase)].merge!({line[1] => line[3]}) if data.has_key?(line[0].upcase)
      data[(line[0].upcase)] = { line[1] =>line[3] } unless data.has_key?(line[0].upcase)
    end
    data
  end

end

class TestingParser
  attr_accessor :csv_data

  def load_data(path)
    @csv_data = CSV.open(path, {:headers => true, header_converters: :symbol})
  end

  def get_testing_data
    data = {}
    testing = @csv_data.readlines.each do |line|
      if data.has_key?(line[0].upcase) && data[line[0].upcase][line[2]].nil?
        data[(line[0].upcase)].merge!({line[2] => { line[1] =>line[4] }})
      elsif !(data.has_key?(line[0].upcase))
        data[(line[0].upcase)] = {line[2] => { line[1] =>line[4] }}
      else
        data[(line[0].upcase)][line[2]].merge!({ line[1] =>line[4] }) #if data[line[0].upcase][line[2]]
      end
    end
    data
  end

end

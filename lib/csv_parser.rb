require 'csv'

class BasicParser
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
      if data.has_key?(line[0].upcase)
        data[(line[0].upcase)].merge!({line[1].to_i => line[3].to_f})
      else
        data[(line[0].upcase)] = { line[1].to_i =>line[3].to_f }
      end
    end
    data
  end

end

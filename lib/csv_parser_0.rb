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
      data[(line[0].upcase)].merge!({line[1].to_i => line[3].to_f}) if data.has_key?(line[0].upcase)
      data[(line[0].upcase)] = { line[1].to_i =>line[3].to_f } unless data.has_key?(line[0].upcase)
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
      if data.has_key?(line[0].upcase) && data[line[0].upcase][line[2].to_i].nil?
        data[(line[0].upcase)].merge!({line[2].to_i => { line[1].downcase.tr(" ", "_").to_sym =>line[4].to_f }})
      elsif !(data.has_key?(line[0].upcase))
        data[(line[0].upcase)] = {line[2].to_i => { line[1].downcase.tr(" ", "_").to_sym =>line[4].to_f }}
      else
        data[(line[0].upcase)][line[2].to_i].merge!({ line[1].downcase.tr(" ", "_").to_sym =>line[4].to_f }) #if data[line[0].upcase][line[2]]
      end
    end
    data
  end

end

class EconomicParser
  attr_accessor :csv_data

  def load_data(path)
    @csv_data = CSV.open(path, {:headers => true, header_converters: :symbol})
  end

  def get_income_data
    data = {}
    testing = @csv_data.readlines.each do |line|
      data[(line[0].upcase)].merge!({[line[:timeframe][0..3].to_i, line[:timeframe][5..8].to_i] => line[3].to_f}) if data.has_key?(line[0].upcase)
      data[(line[0].upcase)] = { [line[:timeframe][0..3].to_i, line[:timeframe][5..8].to_i] =>line[3].to_f } unless data.has_key?(line[0].upcase)
    end
    data
  end

  def get_lunch_data
    data = {}
    testing = @csv_data.readlines.each do |line|
      if line[1].include?("Free or Reduced")
        if data.has_key?(line[0].upcase) && !data[line[0].upcase][line[1]][line[2].to_i].nil?
          data[(line[0].upcase)][line[1]][line[2].to_i].merge!({ line[3].to_sym =>line[4].to_f })
        elsif !(data.has_key?(line[0].upcase))
          data[(line[0].upcase)] = {line[1] => { line[2].to_i => {line[3].to_sym => line[4].to_f}}}
        else
          data[(line[0].upcase)][line[1]].merge!({ line[2].to_i => {line[3].to_sym => line[4].to_f}})
        end
      end
    end
    data
  end

end

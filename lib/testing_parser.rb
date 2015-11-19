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
        data[(line[0].upcase)][line[2].to_i].merge!({ line[1].downcase.tr(" ", "_").to_sym =>line[4].to_f })
      end
    end
    data
  end

end

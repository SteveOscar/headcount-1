class EconomicParser
  attr_accessor :csv_data

  def load_data(path)
    @csv_data = CSV.open(path, {:headers => true, header_converters: :symbol})
  end

  def get_income_data
    data = {}
    testing = @csv_data.readlines.each do |line|
      if data.has_key?(line[0].upcase)
        data[(line[0].upcase)].merge!({[line[:timeframe][0..3].to_i, line[:timeframe][5..8].to_i] => line[3].to_f})
      else
        data[(line[0].upcase)] = { [line[:timeframe][0..3].to_i, line[:timeframe][5..8].to_i] =>line[3].to_f }
      end
    end
    data
  end

  def get_lunch_data
    data = {}
    testing = @csv_data.readlines.each do |line|
      if line[1].include?("Free or Reduced")
        if data.has_key?(line[0].upcase) && !data[line[0].upcase][line[2].to_i].nil?
          data[(line[0].upcase)][line[2].to_i].merge!({ type(line[3]) =>line[4].to_f })
        elsif !(data.has_key?(line[0].upcase))
          data[(line[0].upcase)] =  { line[2].to_i => {type(line[3]) => line[4].to_f}}
        else
          data[(line[0].upcase)].merge!({ line[2].to_i => {type(line[3]) => line[4].to_f}})
        end
      end
    end
    data
  end

  def lunch
    :free_or_reduced_price_lunch
  end

  def type(category)
    if category == "Percent"
      :percentage
    else
      :total
    end
  end

end

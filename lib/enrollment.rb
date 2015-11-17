require 'pry'

class Enrollment
  attr_reader :district, :enrollment_data, :grade, :name

  def initialize(data)
    @district = data.values[0]
    @name = district
    @enrollment_data = convert_enrollment_header(data)
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

  def kindergarten_participation_by_year
    enrollment_data
  end

  def kindergarten_participation_in_year(year)
    truncate(enrollment_data[:kindergarten][year].to_f)
  end

  def graduation_rate_by_year
    truncate_data_values(enrollment_data[:high_school_graduation])
  end

  def graduation_rate_in_year(year)
    truncate(enrollment_data[:high_school_graduation][year].to_f)
  end

  def truncate_data_values(data)
    truncated_data = {}
    data.each do |k, v|
      truncated_data[k] = truncate(v)
    end
    truncated_data
  end

  def convert_enrollment_header(data)
    if data.keys[1] == :kindergarten_participation
      h = {:kindergarten => data.values[1]}
    else
      h = {data.keys[1] => data.values[1]}
    end
    h
  end

end

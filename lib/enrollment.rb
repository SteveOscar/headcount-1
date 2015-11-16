require 'pry'

class Enrollment
  attr_reader :district, :enrollment_data, :grade, :name

  def initialize(data)
    @district = data.values[0]
    @name = district
    @enrollment_data = {data.keys[1] => data.values[1]}
  end

  def kindergarten_participation_by_year
    enrollment_data
  end

  def kindergarten_participation_in_year(year)
    enrollment_data[:kindergarten][year].round(3)
  end

  def graduation_rate_by_year
    enrollment_data[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    enrollment_data[:high_school_graduation][year.to_s].to_f.round(3)
  end

end

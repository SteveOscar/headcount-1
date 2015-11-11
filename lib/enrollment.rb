require 'pry'

class Enrollment
  attr_reader :district, :enrollment_data, :grade

  def initialize(data)
    @district = data.values[0]
    @enrollment_data = {data.keys[1] => data.values[1]}
  end

  def kindergarten_participation_by_year
    enrollment_data
  end

  def kindergarten_participation_in_year(year)
    enrollment_data[year].round(3)
  end

end

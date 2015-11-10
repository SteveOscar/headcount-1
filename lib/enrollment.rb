require 'pry'

class Enrollment
  attr_reader :name, :enrollment_data

  def initialize(name)
    @name = name.values[0]
    @enrollment_data = name.values[1]
  end

  def kindergarten_participation_by_year
    enrollment_data
  end

  def kindergarten_participation_in_year(year)
    @enrollment_data[year].round(3)
  end

end

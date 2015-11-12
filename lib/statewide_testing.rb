require 'pry'

class StatewideTesting
  attr_reader :district, :statewide_testing_data, :grade

  def initialize(data)
    @district = data.values[0]
    @statewide_testing_data = {data.keys[1] => data.values[1]}
  end

  def proficient_by_grade(grade)
    if grade == 3
      statewide_testing_data[:third_grade]
    elsif grade == 8
      statewide_testing_data[:eigth_grade]
    end
  end

end

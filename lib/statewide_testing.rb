require 'pry'

class StatewideTesting
  attr_reader :district, :statewide_testing_data, :grade

  def initialize(data)
    @district = data.values[0]
    @statewide_testing_data = {data.keys[1] => data.values[1]}
  end

  def proficient_by_grade(grade) ## we tested with 'COLORADO', but we need to specificy COLORADO?
    if grade == 3
      statewide_testing_data[:third_grade]
    elsif grade == 8
      statewide_testing_data[:eigth_grade]
    end
  end

  def proficient_by_race_or_ethnicity(race)
    ## raise error if race != [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    data = {}
    statewide_testing_data[:math].each do |key|
      data.merge!({ key[0] => {:math => key[1][race.to_s.capitalize].to_f.round(3) }})
    end
    statewide_testing_data[:reading].each do |key|
      data[key[0]].merge!({:reading => key[1][race.to_s.capitalize].to_f.round(3) })
    end
    statewide_testing_data[:writing].each do |key|
      data[key[0]].merge!({:writing => key[1][race.to_s.capitalize].to_f.round(3) })
    end
    data
  end

end

# def proficient_by_race_or_ethnicity(race)
#   ## raise error if race != [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
#   data = {}
#   statewide_testing_data[:math].each do |key|
#     binding.pry
#     data.merge!({ key[0] => {:math => key[1][race.to_s.capitalize].to_f.round(3) }})
#   end
#   statewide_testing_data[:reading].each { |key| add_data(key, data, race) }
#   statewide_testing_data[:writing].each { |key| add_data(key, data, race) }
#   binding.pry
#   data
# end
#
# def add_data(key, data, race)
#   data[key[0]].merge!({:reading => key[1][race.to_s.capitalize].to_f.round(3) })
# end

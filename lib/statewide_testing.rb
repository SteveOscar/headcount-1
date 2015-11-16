require 'pry'

class StatewideTesting
  attr_reader :district, :test_data, :grade

  def initialize(data)
    @district = data.values[0]
    @test_data = {data.keys[1] => data.values[1]}
  end

  def years
    [2008, 2009, 2010, 2011, 2012, 2013, 2014]
  end

  def races
    [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def subjects
    [:math, :reading, :writing]
  end

  def proficient_by_grade(grade) ## we tested with 'COLORADO', but we need to specificy COLORADO?
    if grade == 3
      test_data[:third_grade]
    elsif grade == 8
      test_data[:eigth_grade]
    else
      raise UnknownDataError.new
    end
  end

  def proficient_by_race_or_ethnicity(race)
    if !races.include?(race)
      raise UnknownRaceError.new
    else
      data = {}
      test_data[:math].each { |key| data.merge!({ key[0] => {:math => data(race, key) }}) }
      test_data[:reading].each { |key| data[key[0]].merge!({:reading => data(race, key) }) }
      test_data[:writing].each { |key| data[key[0]].merge!({:writing => data(race, key) }) }
    end
    data
  end

  def data(race, key)
    key[1][race.to_s.capitalize].to_f.round(3)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError.new if !subjects.include?(subject)
    raise UnknownDataError.new if !years.include?(year)
    raise UnknownDataError.new if grade != 3 && grade != 8
    case grade
    when 3
      grade = :third_grade
    when 8
      grade = :eigth_grade
    else
      raise UnknownDataError.new
    end
    (test_data[grade][year.to_s][subject.to_s.capitalize]).to_f
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError.new if !subjects.include?(subject)
    raise UnknownDataError.new if !years.include?(year)
    raise UnknownDataError.new if !races.include?(race)
    (test_data[subject][year.to_s][race.to_s.capitalize]).to_f.round(3)
  end

end

class UnknownDataError < StandardError
end

class UnknownRaceError < StandardError
end

# def proficient_by_race_or_ethnicity(race)
#   ## raise error if race != [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
#   data = {}
#   test_data[:math].each do |key|
#     binding.pry
#     data.merge!({ key[0] => {:math => key[1][race.to_s.capitalize].to_f.round(3) }})
#   end
#   test_data[:reading].each { |key| add_data(key, data, race) }
#   test_data[:writing].each { |key| add_data(key, data, race) }
#   binding.pry
#   data
# end
#
# def add_data(key, data, race)
#   data[key[0]].merge!({:reading => key[1][race.to_s.capitalize].to_f.round(3) })
# end

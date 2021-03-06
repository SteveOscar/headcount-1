require 'pry'
require_relative 'error_classes'

class StatewideTest
  attr_reader :district, :test_data, :grade

  def initialize(data)
    @district = data.values[0]
    @test_data = {data.keys[1] => data.values[1]}
  end

  def truncate_hash_values(data)
    test_data.each do |k, v|
      data[k].each { |k, data| data.update(data){ |k, v| truncate(v) } }
    end
  end

  def proficient_by_grade(grade)
    truncate_hash_values(test_data)
    error_check(:math, 2010, grade)
    grade == 3 ? test_data[:third_grade] : test_data[:eighth_grade]
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError.new if !races.include?(race)
    data = {}
    test_data[:math].each { |key| data.merge!({ key[0] => {:math => truncate(key[1][race]) }})}
    test_data[:reading].each { |key| data[key[0]].merge!({:reading => truncate(key[1][race]) }) }
    test_data[:writing].each { |key| data[key[0]].merge!({:writing => truncate(key[1][race]) }) }
    data
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    error_check(subject, year, grade)
    grade == 3 ? grade = :third_grade : grade = :eighth_grade
    format_profeiciency_result(subject, grade, year)
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    error_check(subject, year, 3, race)
    truncate((test_data[subject][year][race]).to_f)
  end

  def error_check(subject, year, grade, race=:asian)
    raise UnknownDataError.new unless [:math, :reading, :writing].include?(subject)
    raise UnknownDataError.new unless (2008..2014).include?(year)
    raise UnknownDataError.new unless grade == 3 || grade == 8
    raise UnknownDataError.new unless races.include?(race)
  end

  def format_profeiciency_result(subject, grade, year)
    answer = truncate((test_data[grade][year][subject]).to_f)
    answer == 0.0 ? "N/A" : answer
  end

  def races
    [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

  def data(race, key)
    truncate(key[1][race.to_s.capitalize].to_f)
  end

end

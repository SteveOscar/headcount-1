
module StatewideAnalytics

  def format_grade_argument(argument)
    argument = :third_grade if argument == 3
    argument = :eigth_grade if argument == 8
    argument
  end

  def format_subject_argument(arguments)
    subjects = [:reading, :writing, :math] if !arguments.has_key?(:subject)
    subjects = [arguments[:subject]] if arguments.has_key?(:subject)
    subjects
  end

  def format_top_argument(arguments)
    top = 1 if !arguments.has_key?(:top)
    top = arguments[:top] if arguments.has_key?(:top)
    top
  end

  def hash_of_all_district_results(subjects, grade)
    dists_results = {}
    subjects.each do |subject|
      dists_results[subject] = get_all_districts_growth_per_subject(grade, subject)
    end
    dists_results
  end

  def top_statewide_test_year_over_year_growth(arguments)
    raise InsufficientInformationError.new, 'A grade must be provided to answer this question' unless arguments.has_key?(:grade)
    raise UnknownDataError.new, "#{arguments[:grade]} is not a known grade" unless arguments[:grade] == 3 || arguments[:grade] == 8
    grade = format_grade_argument(arguments[:grade])
    subjects = format_subject_argument(arguments)
    top = format_top_argument(arguments)
    growth = calculate_growth(hash_of_all_district_results(subjects, grade))
    calculate_final_change(growth, top, subjects)
  end

  def calculate_growth(dists_results)
    growth = {}
    dists_results.each do |subject, values|
      values.each do |dist, percentage|
        growth.has_key?(dist) ? growth[dist] += percentage : growth[dist] = percentage
      end
    end
    growth
  end

  def calculate_final_change(growth, top, subjects)
    answer = find_top_district(growth, top)
    result = answer.map { |element| [element[0], (element[1] / subjects.size)] }
    result.length == 1 ? result = result[0] : result
  end

  def get_all_districts_growth_per_subject(grade, subject)
    results = {}
    dr.districts.each do |district|
      results.merge!({district.name => district_change(grade, subject, district.name)})
    end
    results
  end

  def find_top_district(results, top)
    top_district = []
    top.times do
      top_district << results.max_by{ |k, v| v }
      results.delete(top_district.last[0])
    end
    top_district
  end

  def district_change(grade, subject, district)
    years = dr.find_by_name(district).statewide_testing.test_data[grade]
    array = years.map { |year| (year[1][subject.to_s.capitalize]).to_f }
    differences = get_differences_between_years(array)
    (differences.reduce(:+) / differences.length).round(3)
  end

  def get_differences_between_years(array)
    i = 1
    differences = []
    loop do
      differences << (array[i] - array[i-1])
      i += 1
      break if i == array.size
    end
    differences
  end
end

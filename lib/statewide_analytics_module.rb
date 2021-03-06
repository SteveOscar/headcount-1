module StatewideAnalytics

  def format_grade(argument)
    argument = :third_grade if argument == 3
    argument = :eighth_grade if argument == 8
    argument
  end

  def format_subject(arguments)
    subjects = [:reading, :writing, :math] if !arguments.has_key?(:subject)
    subjects = [arguments[:subject]] if arguments.has_key?(:subject)
    subjects
  end

  def format_top(arguments)
     arguments.has_key?(:top) ? top = arguments[:top] : top = 1
  end

  def get_weighting_hash(arguments)
    arguments[:weighting] if arguments.keys.include?(:weighting)
  end

  def top_statewide_test_year_over_year_growth(arguments)
    raise_error_for_bad_arguments(arguments)
    weighting = get_weighting_hash(arguments)
    grade = format_grade(arguments[:grade])
    subjects = format_subject(arguments)
    top = format_top(arguments)
    growth = calculate_growth(hash_of_all_district_results(subjects, grade, weighting))
    calculate_final_change(growth, top, subjects, weighting)
  end

  def hash_of_all_district_results(subjects, grade, weighting)
    dists_results = {}
    subjects.each do |subject|
      dists_results[subject] = get_all_districts_growth_per_subject(grade, subject, weighting)
    end
    dists_results
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

  def get_all_districts_growth_per_subject(grade, subject, weighting)
    results = {}
    dr.districts.each do |district|
      results.merge!({district.name => district_change(grade, subject, district.name, weighting)})
    end
    results
  end

  def district_change(grade, subject, district, weighting=nil)
    years = dr.find_by_name(district).statewide_test.test_data[grade]
    data = Hash[ years.keys.zip(years.map { |year| (year[1][subject]).to_f })]
    data.delete_if{|_,v| v == 0.0}
    calculate_change_over_time(data, weighting, subject)
  end

  def calculate_change_over_time(data, weighting, subject)
    if data.values.length > 1
      subject_average = (data.values.last - data.values[0]) / (data.keys.last - data.keys[0])
    else
      subject_average = 0
    end
    subject_average = (subject_average * (weighting[subject] * 10)) unless weighting.nil?
    subject_average
  end

  def calculate_final_change(growth, top, subjects, weighting=nil)
    answer = find_top_district(growth, top)
    result = (answer.map { |element| [element[0], (truncate(element[1] / subjects.size))]}) if weighting.nil?
    result = (answer.map { |element| [element[0], (truncate(element[1] / 10))]}) unless weighting.nil?
    result.length == 1 ? result = result[0] : result
  end

  def find_top_district(results, top)
    top_district = []
    top.times do
      top_district << results.max_by{ |k, v| v }
      results.delete(top_district.last[0])
    end
    top_district
  end

  def raise_error_for_bad_arguments(arguments)
    raise InsufficientInformationError.new, 'A grade must be provided to answer this question' unless arguments.has_key?(:grade)
    raise UnknownDataError.new, "#{arguments[:grade]} is not a known grade" unless arguments[:grade] == 3 || arguments[:grade] == 8
  end

end

module KindergartenAnalytics

    def kindergarten_participation_rate_variation_trend(district, compared_to)
      answers = {}
      initial = dr.find_by_name(district).enrollment.enrollment_data.values.first
      comparison = dr.find_by_name(compared_to.values.join).enrollment.enrollment_data.values.first
      initial.each { |k, v| answers[k] = (v.to_f / comparison[k].to_f).round(3) }
      answers
    end

    def kindergarten_participation_against_high_school_graduation(district)
      kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
      initial = dr.find_by_name(district)
      comparison = dr.find_by_name("COLORADO")
      (kindergarten_variation / (find_variation(initial, comparison, :high_school_graduation))).round(3)
    end

    def district_rate_shows_correlation?(rate)
      0.6 < rate && rate < 1.5
    end

    def district_kindergarten_participation_correlated_with_high_school_graduation?(district)
      rate = kindergarten_participation_against_high_school_graduation(district)
      district_rate_shows_correlation?(rate)
    end

    def kindergarten_participation_correlates_with_high_school_graduation(hash) ######changed colorado to statewide, update tests
      if hash == {:for => "STATEWIDE"}
        statewide_kindergarten_rates_show_correlation?
      elsif hash.keys == [:for]
        district_kindergarten_participation_correlated_with_high_school_graduation?(hash[:for])
      else
        districts = hash[:across]
        correlated_districts = districts.select do |d|
          district_kindergarten_participation_correlated_with_high_school_graduation?(d)
        end
        correlated_districts.count / districts.count.to_f >= 0.7
      end
    end

    def statewide_kindergarten_rates_show_correlation?
      rate = kindergarten_participation_against_high_school_graduation("COLORADO")
      rate >= 0.7
    end
end
module StatewideAnalytics

  def top_statewide_test_year_over_year_growth(grade, subjects = [:reading, :writing, :math], top=1)
    districts_results = {}
    subjects = [subjects] unless subjects.class == Array
    subjects.each do |subject|
      districts_results[subject] = get_all_districts_growth_per_subject(grade, subject)
    end
    districts_overall_growth = {}
    districts_results.each do |subject, district_score_pair|
      district_score_pair.each do |district, percentage|
        if districts_overall_growth.has_key?(district)
          districts_overall_growth[district] += percentage
        else
          districts_overall_growth[district] = percentage
        end
      end
    end
    answer = find_top_district(districts_overall_growth, top)
    result = answer.map do |element|
      [element[0], (element[1] / subjects.size)]
    end
    result = result[0] if result.length == 1
    result

  end

  def get_all_districts_growth_per_subject(grade, subject)
    results = {}
    dr.districts.each do |district|
      results.merge!({district.district => get_district_year_over_year(grade, subject, district.district)})
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

  def get_district_year_over_year(grade, subject, district)
    found_district = dr.find_by_name(district)
    years = found_district.statewide_testing.test_data[grade]
    array = years.map do |year|
      (year[1][subject.to_s.capitalize]).to_f
    end
    i = 1
    differences = []
    loop do
      differences << (array[i] - array[i-1])
      i += 1
      break if i == array.size
    end
    answer = differences.reduce(:+) / differences.length
    answer.round(3)
  end







end

class HeadcountAnalyst
  include KindergartenAnalytics
  include StatewideAnalytics
  attr_reader :dr

  def initialize(dr = nil)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(district, compared_to)
    initial = dr.find_by_name(district)
    comparison = dr.find_by_name(compared_to[:against])
    find_variation(initial, comparison, :kindergarten)
  end

  def average_values(array)
    array = array.values.map(&:to_f)
    answer = array.reduce(:+) / array.length
  end

  def find_variation(initial, comparison, grade)
    num = average_values(initial.enrollment.enrollment_data[grade])
    dem = average_values(comparison.enrollment.enrollment_data[grade])
    (num / dem).round(3)
  end
end

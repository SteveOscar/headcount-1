class HeadcountAnalyst
  attr_reader :dr

  def initialize(dr = nil)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(district, compared_to)
    initial = dr.find_by_name(district)
    comparison = dr.find_by_name(compared_to[:against])
    num = average_values(initial.enrollment.enrollment_data[:kindergarten])
    dem = average_values(comparison.enrollment.enrollment_data[:kindergarten])
    (num / dem).round(3)
  end

  def average_values(array)
    array = array.values.map(&:to_f)
    answer = array.reduce(:+) / array.length
  end

  def kindergarten_participation_rate_variation_trend(district, compared_to)
    answers = {}
    initial = dr.find_by_name(district).enrollment.enrollment_data.values.first
    comparison = dr.find_by_name(compared_to.values.join).enrollment.enrollment_data.values.first
    initial.each do |k, v|
      answers[k] = (v.to_f / comparison[k].to_f).round(3)
    end
    answers
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    initial = dr.find_by_name(district)
    comparison = dr.find_by_name("COLORADO")
    num = average_values(initial.enrollment.enrollment_data[:high_school_graduation])
    dem = average_values(comparison.enrollment.enrollment_data[:high_school_graduation])
    graduation_variation = (num / dem).round(3)
    kindergarten_graduation_variance = (kindergarten_variation / graduation_variation).round(3)
  end


  def kindergarten_participation_correlates_with_high_school_graduation
    1
  end


end

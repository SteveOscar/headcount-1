class HeadcountAnalyst
  attr_reader :dr

  def initialize(dr = nil)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(district, hash)
    initial = @dr.find_by_name(district)
    comparison = @dr.find_by_name(hash.values.join)
    num = average_values(initial.enrollment.enrollment_data.values)
    dem = average_values(comparison.enrollment.enrollment_data.values)
    (num / dem).round(3)
  end

  def average_values(array)
    array = array.map(&:to_f)
    answer = array.reduce(:+) / array.length
  end

  def kindergarten_participation_rate_variation_trend(district, hash)
    answers = {}
    initial = @dr.find_by_name(district).enrollment.enrollment_data
    comparison = @dr.find_by_name(hash.values.join).enrollment.enrollment_data
    initial.each do |k, v|
      answers[k] = (v.to_f / comparison[k].to_f).round(3)
    end
  end



end

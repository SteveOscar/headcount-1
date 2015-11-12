class HeadcountAnalyst
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

  def kindergarten_participation_rate_variation_trend(district, compared_to)
    answers = {}
    initial = dr.find_by_name(district).enrollment.enrollment_data.values.first
    comparison = dr.find_by_name(compared_to.values.join).enrollment.enrollment_data.values.first
    initial.each { |k, v| answers[k] = (v.to_f / comparison[k].to_f).round(3) }
    answers
  end

  def kindergarten_participation_against_high_school_graduation(district)
    district = district.values[0] if district.class == Hash
    kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    initial = dr.find_by_name(district)
    comparison = dr.find_by_name("COLORADO")
    (kindergarten_variation / (find_variation(initial, comparison, :high_school_graduation))).round(3)
  end


  def kindergarten_participation_correlates_with_high_school_graduation(hash)
    test = kindergarten_participation_against_high_school_graduation(hash)
    if hash.values[0] == "COLORADO" && test >= 0.7
      return true
    elsif 0.6 < test && test < 1.5 && hash.values[0] != "COLORADO"
      return true
    else
      return false
    end


  end


end

class HeadcountAnalyst
  attr_reader :dr

  def initialize(dr = nil)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(district, hash)
    initial = @dr.find_by_name(district)
    comparison = @dr.find_by_name(hash.values.join)
    binding.pry
    participation_percentage = average_values(initial.enrollment.enrollment_data.values) / average_values(comparison.enrollment.enrollment_data.values)

  end

  def average_values(array)
    
    answer = array.reduce(:+) / array.length
  end



end

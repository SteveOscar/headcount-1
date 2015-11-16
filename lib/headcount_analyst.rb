require_relative 'error_classes'
require_relative 'kindergarten_analytics_module'
require_relative 'statewide_analytics_module'
include StatewideAnalytics
include KindergartenAnalytics

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
    (array.values.map(&:to_f)).reduce(:+) / array.length
  end

  def find_variation(initial, comparison, grade)
    num = average_values(initial.enrollment.enrollment_data[grade])
    dem = average_values(comparison.enrollment.enrollment_data[grade])
    (num / dem).round(3)
  end
end

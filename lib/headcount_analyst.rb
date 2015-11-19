require_relative 'error_classes'
require_relative 'kindergarten_analytics_module'
require_relative 'statewide_analytics_module'
include StatewideAnalytics
include KindergartenAnalytics
require 'pry'

class HeadcountAnalyst
  attr_reader :dr

  def initialize(dr = nil)
    @dr = dr
  end

  def average_values(array)
    (array.values.map(&:to_f)).reduce(:+) / array.length
  end

  def find_variation(initial, comparison, grade)
    num = average_values(initial.enrollment.enrollment_data[grade])
    dem = average_values(comparison.enrollment.enrollment_data[grade])
    truncate((num / dem))
  end

  def truncate(num)
    (num * 1000).floor / 1000.0
  end

end

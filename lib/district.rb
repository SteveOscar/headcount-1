require 'pry'

class District
  attr_accessor :enrollment, :statewide_test, :economic_profile
  attr_reader :name

  def initialize(district)
    @name = district.values.join
  end

end

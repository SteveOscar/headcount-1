require 'pry'

class District
  attr_accessor :enrollment, :statewide_testing
  attr_reader :district

  def initialize(district)
    @district = district.values.join
  end

end

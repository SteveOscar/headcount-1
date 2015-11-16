require 'pry'

class District
  attr_accessor :enrollment, :statewide_testing
  attr_reader :name

  def initialize(district)
    @name = district.values.join
  end

end

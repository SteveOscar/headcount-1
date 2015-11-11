require 'pry'

class District
  attr_accessor :enrollment
  attr_reader :district

  def initialize(district)
    @district = district.values.join
  end

end

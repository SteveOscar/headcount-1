require 'pry'

class District
  attr_reader :district

  def initialize(district)
    @district = district.values.join
  end

end

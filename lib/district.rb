require 'pry'

class District
  attr_reader :name

  def initialize(name)
    @name = name.values.join
  end

end

abstract class Monster < Entity
  @previous_x : Int32
  @previous_y : Int32

  def initialize(@x, @y)
    @previous_x = @x
    @previous_y = @y
  end
end

require "./monster/*"

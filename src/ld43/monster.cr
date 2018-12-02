abstract class Monster < Entity
  @previous_x : Int32
  @previous_y : Int32

  def initialize(@x, @y)
    @previous_x = @x
    @previous_y = @y
  end

  def collides_with(other : Monster); end
end

require "./monster/*"

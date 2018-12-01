class Wall < Entity
  property invisible : Bool = false

  def initialize(@x, @y, @invisible); end

  def draw
    return if invisible
    Molly.set_color(Color.new(100, 100, 100))
    Molly.draw_rect(@x, @y, 1.tiles, 1.tiles)
  end
end

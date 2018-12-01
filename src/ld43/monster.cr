class Monster < Entity
  def draw
    Molly.set_color(Color.new(200, 100, 100))
    Molly.draw_rect(@x, @y, 1.tiles, 1.tiles)
  end
end

class Tombstone < Entity
  def draw
    Molly.draw_sprite(@x, @y, Molly.load_sprite("res/statue.png"), stretch_x: 3, stretch_y: 3)
  end
end

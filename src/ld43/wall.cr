class Wall < Entity
  ROOF     = "res/wall-roof.png"
  ROOF_TEE = "res/wall-roof-tee.png"
  SIDE     = "res/wall-side.png"
  SIDE_TEE = "res/wall-side-tee.png"
  INVIS    = ""
  @sprite : String

  def initialize(@x, @y, @sprite = SIDE); end

  def draw
    return if @sprite == INVIS

    Molly.draw_sprite(@x, @y, Molly.load_sprite(@sprite), stretch_x: 3, stretch_y: 3)
  end
end

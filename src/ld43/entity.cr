abstract class Entity
  property x : Int32
  property y : Int32
  property delete_me = false
  property height : Int32 = 1.tiles
  property width : Int32 = 1.tiles

  def initialize(@x, @y); end

  def update(dt); end

  def draw; end
end

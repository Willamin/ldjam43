abstract class Entity
  property x : Int32
  property y : Int32
  property delete_me = false
  property height : Int32 = 1.tiles
  property width : Int32 = 1.tiles

  def initialize(@x, @y); end

  def update(dt); end

  def draw; end

  def collides_with_anything
    (Molly.all_objects - [self]).each do |obj|
      if collides_with(obj)
        collision(obj)
        obj.collision(self)
        return true
      end
    end
    false
  end

  def collides_with(other)
    self.x < other.x + other.width &&
      other.x < self.x + other.width &&
      self.y < other.y + other.height &&
      other.y < self.y + other.height
  end

  def collision(other : Entity); end
end

class Player < Entity
  @previous_x : Int32
  @previous_y : Int32
  getter hit_points = 3
  getter hit_points_max = 3
  property speed = 300
  @invincible : Float64 = 0

  def initialize(@x, @y)
    @previous_x = @x
    @previous_y = @y
  end

  def update(dt)
    @invincible -= dt
    @invincible = 0 if @invincible <= 0
    @previous_x = @x
    @previous_y = @y

    if Molly.keyboard_pressed?(Key::RIGHT)
      @x += (speed * dt).to_i
      if collides_with_anything
        @x = @previous_x
      end
    end

    if Molly.keyboard_pressed?(Key::LEFT)
      @x -= (speed * dt).to_i
      if collides_with_anything
        @x = @previous_x
      end
    end

    if Molly.keyboard_pressed?(Key::DOWN)
      @y += (speed * dt).to_i
      if collides_with_anything
        @y = @previous_y
      end
    end

    if Molly.keyboard_pressed?(Key::UP)
      @y -= (speed * dt).to_i
      if collides_with_anything
        @y = @previous_y
      end
    end
  end

  def draw
    Molly.set_color(Color.new(100, 100, 200))
    if @invincible > 0
      Molly.set_color(Color.new(200, 150, 250))
    end
    Molly.draw_rect(@x, @y, 1.tiles, 1.tiles)
  end

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

  def collision(m : Monster)
    return if @invincible > 0
    @invincible = 2
    @hit_points -= 1
  end
end

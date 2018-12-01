class Player < Entity
  @previous_x : Int32
  @previous_y : Int32
  property speed = 300

  def initialize(@x, @y)
    @previous_x = @x
    @previous_y = @y
  end

  def update(dt)
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
    Molly.draw_rect(@x, @y, 1.tiles, 1.tiles)
  end

  def collides_with_anything
    (Molly.all_objects - [self]).each do |obj|
      if collides_with(obj)
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
end

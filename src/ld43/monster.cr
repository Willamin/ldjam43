class Monster < Entity
  @previous_x : Int32
  @previous_y : Int32
  @steps_til_new_direction : Int32
  @multiplier = 0

  def initialize(@x, @y)
    @previous_x = @x
    @previous_y = @y
    @steps_til_new_direction = 0
  end

  def update(dt)
    if (@steps_til_new_direction -= 1) <= 0
      if Random.new.next_bool
        @multiplier = 1
      else
        @multiplier = -1
      end
      @steps_til_new_direction = 10 * (Random.rand(5) + 2)
    end

    @x += (@multiplier * 100 * dt).to_i
    if collides_with_anything
      @x = @previous_x
    end
    @previous_x = @x
  end

  def draw
    Molly.set_color(Color.new(200, 100, 100))
    Molly.draw_rect(@x, @y, 1.tiles, 1.tiles)
  end
end

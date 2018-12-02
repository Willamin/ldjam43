class Dumb < Monster
  SPRITE = "res/slime.png"

  def initialize(@x, @y)
    super
    @steps_til_new_direction = 0
    @multiplier = 0
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
    Molly.draw_sprite(x, y, Molly.load_sprite(SPRITE), stretch_x: 3, stretch_y: 3)
  end
end

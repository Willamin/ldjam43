class Follow < Monster
  SPRITE = "res/spider.png"
  @countdown : Float64 = 1
  @moving : Bool = false

  def initialize(@x, @y)
    super
    @previous_x = @x
    @previous_y = @y
  end

  def update(dt)
    if @moving
      move(dt)
    end

    if @countdown <= 0
      if @moving
        @countdown = 0.25
        @moving = false
      else
        @countdown = 0.25
        @moving = true
      end
    end

    @countdown -= dt
  end

  def draw
    Molly.draw_sprite(@x, @y, Molly.load_sprite(SPRITE), stretch_x: 3, stretch_y: 3)
  end

  def move(dt)
    return unless Molly.player.is_a?(Player)
    target_x = Molly.player.x
    target_y = Molly.player.y

    speed_x = target_x - @x
    speed_y = target_y - @y
    factor = Math.sqrt(speed_x**2 + speed_y**2)
    unless factor == 0
      @x += (speed_x * (200 / factor) * dt).to_i
      @x = @previous_x if collides_with_anything
    end

    unless factor == 0
      @y += (speed_y * (200 / factor) * dt).to_i
      @y = @previous_y if collides_with_anything
    end

    @previous_x = @x
    @previous_y = @y
  end
end

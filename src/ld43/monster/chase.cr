class Chase < Monster
  SPRITE = "res/bat.png"
  @mode = :wandering

  def initialize(@x, @y)
    super
    @previous_x = @x
    @previous_y = @y
  end

  def update(dt)
    chase(dt) if @mode == :chasing
    wander(dt) if @mode == :wandering

    distance_to_player = Math.sqrt((Molly.player.x - @x)**2 + (Molly.player.y - @y)**2)
    if distance_to_player < 5.tiles
      @mode = :chasing
    else
      @mode = :wandering
    end
  end

  def draw
    Molly.draw_sprite(@x, @y, Molly.load_sprite(SPRITE), stretch_x: 3, stretch_y: 3)

    # Molly.set_color(Color.new(0, 0, 0))
    # Molly.draw_text(3.tiles, 8.tiles, "mode: #{@mode}\ndir: #{@wander_direction}\ndist: #{@wandered_distance}")
  end

  def chase(dt)
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

  @wander_direction = :down
  @wandered_distance : Float64 = 0
  DIRECTIONS = [:up, :down, :left, :right]

  def wander(dt)
    if @wandered_distance > 2.tiles
      @wandered_distance = 0
      @wander_direction = DIRECTIONS.shuffle.first
    end

    speed = 100 * dt

    case @wander_direction
    when :up
      @y -= speed.to_i
      if collides_with_anything
        @y = @previous_y
      else
        @wandered_distance += speed
      end
    when :down
      @y += speed.to_i
      if collides_with_anything
        @y = @previous_y
      else
        @wandered_distance += speed
      end
    when :left
      @x -= speed.to_i
      if collides_with_anything
        @x = @previous_x
      else
        @wandered_distance += speed
      end
    when :right
      @x -= speed.to_i
      if collides_with_anything
        @x = @previous_x
      else
        @wandered_distance += speed
      end
    end
  end
end

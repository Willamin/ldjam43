class Player < Entity
  LEFT  = "res/man-left.png"
  RIGHT = "res/man-right.png"
  UP    = "res/man-up.png"
  DOWN  = "res/man-down.png"
  @previous_x : Int32
  @previous_y : Int32
  getter hit_points : Int32
  getter hit_points_max : Int32
  property speed = 300
  @invincible : Float64 = 0
  @facing = DOWN
  @blink_timer : Float64 = 0

  def initialize(@x, @y)
    @previous_x = @x
    @previous_y = @y
    @hit_points = 3
    @hit_points_max = 3
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
      else
        @facing = RIGHT
      end
    end

    if Molly.keyboard_pressed?(Key::LEFT)
      @x -= (speed * dt).to_i
      if collides_with_anything
        @x = @previous_x
      else
        @facing = LEFT
      end
    end

    if Molly.keyboard_pressed?(Key::DOWN)
      @y += (speed * dt).to_i
      if collides_with_anything
        @y = @previous_y
      else
        @facing = DOWN
      end
    end

    if Molly.keyboard_pressed?(Key::UP)
      @y -= (speed * dt).to_i
      if collides_with_anything
        @y = @previous_y
      else
        @facing = UP
      end
    end

    if @x != @previous_x && @y != @previous_y
      prop_x = @x - @previous_x
      prop_y = @y - @previous_y
      @x = (@previous_x + prop_x * 0.707).to_i
      @y = (@previous_y + prop_y * 0.707).to_i
    end

    if @invincible > 0 && @blink_timer <= 0
      @blink_timer = 10
    end
    @blink_timer -= 1
  end

  def draw
    return if @invincible > 0 && @blink_timer < 5
    Molly.draw_sprite(x, y, Molly.load_sprite(@facing), stretch_x: 3, stretch_y: 3)
  end

  def collision(m : Monster)
    return if @invincible > 0
    @invincible = 2
    @hit_points -= 1
  end
end

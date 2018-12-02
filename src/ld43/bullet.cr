class Bullet < Entity
  def initialize(@x, @y, @direction : String)
    height = 1.tiles / 4
    width = 1.tiles / 4
  end

  def update(dt)
    speed = 200
    case @direction
    when Player::UP    then @y -= (speed * dt).to_i
    when Player::DOWN  then @y += (speed * dt).to_i
    when Player::LEFT  then @x -= (speed * dt).to_i
    when Player::RIGHT then @x += (speed * dt).to_i
    end

    if @x < -2.tiles || @y < -2.tiles || @x > 17.tiles || @y > 17.tiles
      @delete_me = true
    end
  end

  def collision(m : Monster)
    m.delete_me = true
    @delete_me = true
    Molly.play_sound(Molly.load_sound("res/kill.wav"))
  end

  def draw
    Molly.set_color(Color.new(240, 240, 240))
    Molly.draw_rect(@x, @y, 1.tiles / 4, 1.tiles / 4)
  end
end

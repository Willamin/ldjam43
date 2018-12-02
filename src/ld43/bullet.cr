class Bullet < Entity
  def initialize(@x, @y, @direction : String)
  end

  def update(dt)
    speed = 200
    case @direction
    when Player::UP    then @y -= (speed * dt).to_i
    when Player::DOWN  then @y += (speed * dt).to_i
    when Player::LEFT  then @x -= (speed * dt).to_i
    when Player::RIGHT then @x += (speed * dt).to_i
    end
  end

  def collision(m : Monster)
    m.delete_me = true
    self.delete_me = true
    Molly.play_sound(Molly.load_sound("res/kill.wav"))
  end

  def draw
    Molly.set_color(Color.new(240, 240, 240))
    Molly.draw_rect(@x, @y, 1.tiles / 4, 1.tiles / 4)
    # Molly.draw_sprite(@x, @y, Molly.load_sprite(@direction))
  end
end

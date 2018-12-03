require "molly2d"
require "./ld43/waves"
require "./ld43/entity"
require "./ld43/*"

module Ld43
  VERSION   = {{ `shards version #{__DIR__}`.chomp.stringify }}
  TILE_SIZE = 48
end

struct Int32
  def pixels
    (self / Ld43::TILE_SIZE).to_i
  end

  def tiles
    self * Ld43::TILE_SIZE
  end
end

module Molly
  data start_pressed : Bool { false }
  data started : Bool { false }
  data player : Player | Tombstone { Player.new(7.tiles, 7.tiles) }
  data drawable_objects : Array(Entity) { [] of Entity }
  data updateable_objects : Array(Entity) { [] of Entity }
  data player_cant_cross : Array(Entity) { [] of Entity }
  data grasses : Array(Tuple(Int32, Int32)) { [] of Tuple(Int32, Int32) }
  data current_wave : Int32 { 0 }
  data wave_queue : Array(Monster.class) { [] of Monster.class }
  data spawn_timer : Float64 { 0_f64 }

  def game_setup
    Molly.updateable_objects = [] of Entity
    Molly.drawable_objects = [] of Entity
    Molly.player_cant_cross = [] of Entity
    Molly.start_pressed = false
    Molly.started = false
    Molly.current_wave = 0
    generate_grasses
    Molly.player = Player.new(7.tiles, 7.tiles)
    create_walls
    # [Dumb.new(9.tiles, 9.tiles),
    #  Follow.new(1.tiles, 1.tiles),
    #  Chase.new(11.tiles, 2.tiles),
    # ].each &.tap do |m|
    #   updateable_objects << m
    #   drawable_objects << m
    # end
  end

  def load
    window.size = {15.tiles, 15.tiles}
    Molly.background = Color.new(62, 41, 52)
    game_setup
  end

  def handle_global_keys(dt)
    if Molly.keyboard_pressed?(Key::SPACE)
      if Molly.player.is_a?(Tombstone)
        game_setup
      end

      Molly.start_pressed = true
    end

    if Molly.start_pressed && !Molly.keyboard_pressed?(Key::SPACE)
      Molly.started = true
    end

    if Molly.keyboard_pressed?(Key::ESCAPE)
      exit(0)
    end
  end

  def handle_player_death(dt)
    player = Molly.player
    if player.is_a?(Player)
      if player.hit_points <= 0
        x = player.x
        y = player.y
        Molly.play_sound(Molly.load_sound("res/die.wav"))
        Molly.player = Tombstone.new(x, y)
      end
    end
  end

  def update(dt)
    handle_global_keys(dt)

    if started
      Molly.spawn_timer -= dt
      Molly.player.update(dt)
      Molly.updateable_objects.reject! do |entity|
        entity.update(dt)
        entity.delete_me
      end

      if number_of_monsters == 0 && Molly.wave_queue.size == 0
        Molly.current_wave += 1
        Molly.spawn_timer = 2_f64
        wave = WAVES[Molly.current_wave]?
        if wave.nil?
          puts("You've cleared all the waves!")
          exit(0)
        end
        wave.monsters.each do |monster|
          Molly.wave_queue << monster
        end
      end

      if !Molly.wave_queue.empty? && Molly.spawn_timer <= 0
        spawn_monster(Molly.wave_queue.pop)
        spawn_delay = WAVES[Molly.current_wave]?.try(&.spawn_delay_base) || 1_f64
        Molly.spawn_timer = spawn_delay + (1..10).to_a.shuffle.first * 0.1
      end
    end

    handle_player_death(dt)
  end

  def number_of_monsters
    Molly.updateable_objects.select(&.is_a?(Monster)).size
  end

  def spawn_monster(m : Monster.class)
    side = [:top, :bottom, :leftside, :rightside].shuffle.first
    monster =
      case side
      when :top       then m.new(7.tiles, -1.tiles)
      when :bottom    then m.new(7.tiles, 15.tiles)
      when :leftside  then m.new(-1.tiles, 7.tiles)
      when :rightside then m.new(15.tiles, 7.tiles)
      end
    monster.try do |monster|
      Molly.updateable_objects << monster
      Molly.drawable_objects << monster
    end
  end

  def draw
    (0..14).each do |x|
      (0..14).each do |y|
        grass_sprite = Molly.load_sprite("res/grass.png")
        grass_sprite = Molly.load_sprite("res/grass-weeds.png") if grasses.includes?({x, y})
        Molly.draw_sprite(x.tiles, y.tiles, grass_sprite, stretch_x: 3, stretch_y: 3)
      end
    end

    if started
      Molly.player.draw
      Molly.drawable_objects.reject!(&.delete_me)
      drawable_objects.sort_by! { |entity| entity.y }
      drawable_objects.each(&.draw)
      player = Molly.player
      if player.is_a?(Player)
        hp_text = "Current Wave: #{Molly.current_wave}\nHit Points: #{player.hit_points} / #{player.hit_points_max}"
      else
        hp_text = "You have died. Press [SPACE] to Restart"
      end
      set_color(Color.new(200, 200, 200))
      draw_rect(3.tiles - 4, 3.tiles - 2, text_width(hp_text) + 8, 48)
      set_color(Color.new(40, 40, 40))
      draw_text(3.tiles, 3.tiles, hp_text)
    else
      start_text = "Press [SPACE] to Start"
      w = text_width(start_text)
      x = 7.tiles + Ld43::TILE_SIZE / 2.0
      x -= w / 2.0
      set_color(Color.new(200, 200, 200))
      draw_rect(x.to_i - 4, 6.tiles - 2, text_width(start_text) + 8, 24)
      set_color(Color.new(40, 40, 40))
      draw_text(x.to_i, 6.tiles, start_text)
    end

    # Molly.draw_text(4.tiles, 8.tiles, "to kill: #{number_of_monsters}")
  end

  def all_objects
    Molly.updateable_objects | Molly.drawable_objects | [Molly.player]
  end

  def create_walls
    # top
    drawable_objects << Wall.new(0.tiles, 0.tiles, Wall::ROOF_TEE)
    5.times { |x| drawable_objects << Wall.new((1 + x).tiles, 0.tiles, Wall::SIDE) }
    3.times { |x| player_cant_cross << Wall.new((6 + x).tiles, 0.tiles, Wall::INVIS) }
    5.times { |x| drawable_objects << Wall.new((9 + x).tiles, 0.tiles, Wall::SIDE) }
    drawable_objects << Wall.new(14.tiles, 0.tiles, Wall::ROOF_TEE)

    # sides
    [0, 14].each do |x|
      4.times { |y| drawable_objects << Wall.new(x.tiles, (1 + y).tiles, Wall::ROOF) }
      drawable_objects << Wall.new(x.tiles, 5.tiles, Wall::SIDE_TEE)
      3.times { |y| player_cant_cross << Wall.new(x.tiles, (6 + y).tiles, Wall::INVIS) }
      5.times { |y| drawable_objects << Wall.new(x.tiles, (9 + y).tiles, Wall::ROOF) }
      drawable_objects << Wall.new(x.tiles, 14.tiles, Wall::SIDE_TEE)
    end

    # bottom
    5.times { |x| drawable_objects << Wall.new((1 + x).tiles, 14.tiles, Wall::SIDE) }
    3.times { |x| player_cant_cross << Wall.new((6 + x).tiles, 14.tiles, Wall::INVIS) }
    5.times { |x| drawable_objects << Wall.new((9 + x).tiles, 14.tiles, Wall::SIDE) }

    # boxes
    [{5, -1},
     {6, -2},
     {7, -2},
     {8, -2},
     {9, -1},

     {5, 15},
     {6, 16},
     {7, 16},
     {8, 16},
     {9, 15},

     {-1, 5},
     {-2, 6},
     {-2, 7},
     {-2, 8},
     {-1, 9},

     {15, 5},
     {16, 6},
     {16, 7},
     {16, 8},
     {15, 9},
    ].each do |x, y|
      drawable_objects << Wall.new(x.tiles, y.tiles, Wall::INVIS)
    end
  end

  def generate_grasses
    Molly.grasses = [] of Tuple(Int32, Int32)
    8.times do
      grasses << {1 + Random.rand(14), 1 + Random.rand(14)}
    end
  end
end

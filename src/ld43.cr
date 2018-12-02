require "molly2d"
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
  data grasses : Array(Tuple(Int32, Int32)) { [] of Tuple(Int32, Int32) }

  def game_setup
    Molly.updateable_objects = [] of Entity
    Molly.drawable_objects = [] of Entity
    Molly.start_pressed = false
    Molly.started = false
    generate_grasses
    Molly.player = Player.new(7.tiles, 7.tiles)
    create_walls
    [Dumb.new(9.tiles, 9.tiles),
     Follow.new(1.tiles, 1.tiles),
     Chase.new(11.tiles, 2.tiles),
    ].each &.tap do |m|
      updateable_objects << m
      drawable_objects << m
    end
  end

  def load
    window.size = {15.tiles, 15.tiles}
    Molly.background = Color.new(62, 41, 52)
    game_setup
  end

  def update(dt)
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

    if started
      Molly.player.update(dt)
      Molly.updateable_objects.reject! do |entity|
        entity.update(dt)
        entity.delete_me
      end
    end

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

  def draw
    (0..15).each do |x|
      (0..15).each do |y|
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
        hp_text = "Hit Points: #{player.hit_points} / #{player.hit_points_max}"
      else
        hp_text = "You have died. Press [SPACE] to Restart"
      end
      set_color(Color.new(200, 200, 200))
      draw_rect(3.tiles - 4, 3.tiles - 2, text_width(hp_text) + 8, 24)
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
  end

  def all_objects
    Molly.updateable_objects | Molly.drawable_objects | [Molly.player]
  end

  def create_walls
    # top
    drawable_objects << Wall.new(0.tiles, 0.tiles, Wall::ROOF_TEE)
    5.times { |x| drawable_objects << Wall.new((1 + x).tiles, 0.tiles, Wall::SIDE) }
    3.times { |x| drawable_objects << Wall.new((6 + x).tiles, 0.tiles, Wall::INVIS) }
    5.times { |x| drawable_objects << Wall.new((9 + x).tiles, 0.tiles, Wall::SIDE) }
    drawable_objects << Wall.new(14.tiles, 0.tiles, Wall::ROOF_TEE)

    # sides
    [0, 14].each do |x|
      4.times { |y| drawable_objects << Wall.new(x.tiles, (1 + y).tiles, Wall::ROOF) }
      drawable_objects << Wall.new(x.tiles, 5.tiles, Wall::SIDE_TEE)
      3.times { |y| drawable_objects << Wall.new(x.tiles, (6 + y).tiles, Wall::INVIS) }
      5.times { |y| drawable_objects << Wall.new(x.tiles, (9 + y).tiles, Wall::ROOF) }
      drawable_objects << Wall.new(x.tiles, 14.tiles, Wall::SIDE_TEE)
    end

    # bottom
    5.times { |x| drawable_objects << Wall.new((1 + x).tiles, 14.tiles, Wall::SIDE) }
    3.times { |x| drawable_objects << Wall.new((6 + x).tiles, 14.tiles, Wall::INVIS) }
    5.times { |x| drawable_objects << Wall.new((9 + x).tiles, 14.tiles, Wall::SIDE) }
  end

  def generate_grasses
    Molly.grasses = [] of Tuple(Int32, Int32)
    8.times do
      grasses << {1 + Random.rand(14), 1 + Random.rand(14)}
    end
  end
end

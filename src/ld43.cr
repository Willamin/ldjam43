require "molly2d"
require "./ld43/*"

module Ld43
  VERSION   = {{ `shards version #{__DIR__}`.chomp.stringify }}
  TILE_SIZE = 24
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
  data started : Bool { false }
  data player : Player { Player.new(7.tiles, 7.tiles) }
  data drawable_objects : Array(Entity) { [] of Entity }
  data updateable_objects : Array(Entity) { [] of Entity }

  def load
    window.size = {25.tiles, 25.tiles}
    Molly.background = Color.new(240, 240, 240)

    Molly.player = Player.new(7.tiles, 7.tiles)
    updateable_objects << Molly.player
    drawable_objects << Molly.player

    low = 0
    high = 24
    center = (high / 2 - 1)..(high / 2 + 1)
    (low..high).each { |x| drawable_objects << Wall.new(x.tiles, low.tiles, center.includes?(x)) }
    (low..high).each { |x| drawable_objects << Wall.new(x.tiles, high.tiles, center.includes?(x)) }
    ((low + 1)..(high - 1)).each { |x| drawable_objects << Wall.new(low.tiles, x.tiles, center.includes?(x)) }
    ((low + 1)..(high - 1)).each { |x| drawable_objects << Wall.new(high.tiles, x.tiles, center.includes?(x)) }

    Monster.new(9.tiles, 9.tiles).tap do |m|
      updateable_objects << m
      drawable_objects << m
    end
  end

  def update(dt)
    if Molly.keyboard_pressed?(Key::SPACE)
      Molly.started = true
    end

    if Molly.keyboard_pressed?(Key::ESCAPE)
      exit(0)
    end

    if started
      updateable_objects.reject! do |entity|
        entity.update(dt)
        entity.delete_me
      end
    end

    if Molly.player.hit_points <= 0
      exit(0)
    end
  end

  def draw
    if started
      drawable_objects.sort_by! { |entity| entity.y }
      drawable_objects.each(&.draw)
      set_color(Color.new(40, 40, 40))
      draw_text(3.tiles, 3.tiles, "Hit Points: #{Molly.player.hit_points} / #{Molly.player.hit_points_max}")
    else
      set_color(Color.new(40, 40, 40))
      start_text = "Press [SPACE] to Start"
      w = text_width(start_text)
      x = 7.tiles + Ld43::TILE_SIZE / 2.0
      x -= w/2.0
      draw_text(x.to_i, 6.tiles, start_text)
    end
  end

  def all_objects
    Molly.updateable_objects | Molly.drawable_objects
  end
end

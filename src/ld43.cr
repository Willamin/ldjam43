require "molly2d"
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
  data hit_points : Int32 { 3 }
  data drawable_objects : Array(Entity) { [] of Entity }
  data updateable_objects : Array(Entity) { [] of Entity }

  def load
    window.size = {15.tiles, 15.tiles}
    Molly.background = Color.new(240, 240, 240)

    Player.new(7.tiles, 7.tiles).tap do |p|
      updateable_objects << p
      drawable_objects << p
    end

    (0..14).each { |x| drawable_objects << Wall.new(x.tiles, 0.tiles, (6..8).includes?(x)) }
    (0..14).each { |x| drawable_objects << Wall.new(x.tiles, 14.tiles, (6..8).includes?(x)) }
    (1..13).each { |x| drawable_objects << Wall.new(0.tiles, x.tiles, (6..8).includes?(x)) }
    (1..13).each { |x| drawable_objects << Wall.new(14.tiles, x.tiles, (6..8).includes?(x)) }
  end

  def update(dt)
    updateable_objects.reject! do |entity|
      entity.update(dt)
      entity.delete_me
    end
  end

  def draw
    drawable_objects.sort_by! { |entity| entity.y }
    drawable_objects.each &.draw
    set_color(Color.new(40, 40, 40))
    draw_text(3.tiles, 3.tiles, "Hit Points: #{Molly.hit_points}")
  end

  def all_objects
    Molly.updateable_objects | Molly.drawable_objects
  end
end

class Wave
  getter monsters : Array(Monster.class)
  getter max_on_screen : Int32 = 0
  getter spawn_delay_base : Float64 = 1_f64

  def initialize(@monsters); end

  def initialize(@monsters, @spawn_delay_base); end
end

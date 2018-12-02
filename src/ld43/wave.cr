class Wave
  getter monsters : Array(Monster.class)
  getter max_on_screen : Int32

  def initialize(@max_on_screen, @monsters); end
end

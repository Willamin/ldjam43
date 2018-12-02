require "./wave"
require "./monster/*"

WAVES = [] of Wave

WAVES << Wave.new(1, [] of Monster.class)

([] of Monster.class).tap do |w|
  5.times { w << Follow }
  WAVES << Wave.new(1, w)
end

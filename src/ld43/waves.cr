require "./wave"
require "./monster/*"

WAVES = [] of Wave

WAVES << Wave.new([] of Monster.class)

([] of Monster.class).tap do |w|
  1.times { w << Wander }
  WAVES << Wave.new(w)
end

([] of Monster.class).tap do |w|
  3.times { w << Wander }
  1.times { w << Follow }
  WAVES << Wave.new(w, 0.75)
end

([] of Monster.class).tap do |w|
  1.times { w << Wander }
  5.times { w << Follow }
  WAVES << Wave.new(w, 0.75)
end

([] of Monster.class).tap do |w|
  8.times { w << Follow }
  1.times { w << Chase }
  WAVES << Wave.new(w, 0.75)
end

([] of Monster.class).tap do |w|
  2.times { w << Chase }
  2.times { w << Follow }
  2.times { w << Chase }
  2.times { w << Follow }
  2.times { w << Chase }
  2.times { w << Follow }
  WAVES << Wave.new(w, 0.5)
end

([] of Monster.class).tap do |w|
  8.times { w << Chase }
  8.times { w << Follow }
  8.times { w << Wander }
  w.shuffle!
  WAVES << Wave.new(w, 0.5)
end

([] of Monster.class).tap do |w|
  4.times { w << Chase }
  4.times { w << Follow }
  4.times { w << Wander }
  w.shuffle!
  WAVES << Wave.new(w, 0.2)
end

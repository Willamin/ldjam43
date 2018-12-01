require "option_parser"
require "./ld43"

parser = OptionParser.new do |parser|
  parser.banner = "usage: ld43"

  parser.on("-v", "--version", "display the version") { puts Ld43::VERSION; exit 0 }
  parser.on("-h", "--help", "show this help") { puts parser; exit 0 }
end

parser.parse!
Molly.run

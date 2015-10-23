require './calendar'

Mortalical::Calendar.generate(ARGV[0].to_i, !ARGV.include?("--letter"), !ARGV.include?("--nofill"))
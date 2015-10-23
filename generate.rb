require './calendar'

Mortalical::Calendar.generate(1995, !ARGV.include?("--letter"), !ARGV.include?("--nofill"))
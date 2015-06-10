
# expected format ./gedcom.rb source.ged
unless ARGV.size == 1 && test(?e, ARGV[0]) && File.extname(ARGV[0]) == ".ged"
  puts "Usage: #{$PROGRAM_NAME} GED_SOURCE.ged"
  exit
end
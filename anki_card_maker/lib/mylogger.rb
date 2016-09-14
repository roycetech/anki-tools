require 'logger'

$logger = Logger.new(STDOUT)

$logger.formatter = proc do |severity, datetime, progname, msg|
  
  ECLIPSE = 3
  RAKE = 3
  SUBLIMETEXT2 = 4

  line = caller[RAKE]
  source = line[line.rindex('/', -1)+1 .. -1]
  "#{ severity } #{ source } - #{ msg }\n"
end

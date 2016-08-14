require 'logger'

$logger = Logger.new(STDOUT)

$logger.formatter = proc do |severity, datetime, progname, msg|
  # subscript 3 for eclipse/commandline, 4 for sublime 2
  line = caller[3]
  source = line[line.rindex('/', -1)+1 .. -1]
  "#{severity} #{source} - #{msg}\n"
end

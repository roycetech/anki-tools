require 'logger'

#
module Mylogger
  ECLIPSE = 3
  RAKE = 3
  SUBLIMETEXT2 = 4

  $logger = Logger.new(STDOUT)
  $logger.formatter = proc do |severity, _datetime, _progname, msg|
    line = caller[RAKE]
    source = line[line.rindex('/', -1) + 1..-1]
    "#{severity} #{source} - #{msg}\n"
  end
end

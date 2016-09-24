require 'simplecov'

SimpleCov.start
$unit_test = true

# require './bin/main_class'
require './lib/class_extensions'
require './spec/spec_utils'
require './lib/mylogger'

$logger.level = Logger::WARN



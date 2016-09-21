require 'simplecov'

SimpleCov.start
$unit_test = true

require './bin/main_class'
require './spec/spec_utils'

$logger.level = Logger::DEBUG



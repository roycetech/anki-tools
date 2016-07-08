require 'simplecov'
SimpleCov.start

$unit_test = true

require './bin/main_class'

$logger.level = Logger::WARN


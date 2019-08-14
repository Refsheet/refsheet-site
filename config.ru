# This file is used by Rack-based servers to start the application.
puts "Requiring environment..."
require_relative 'config/environment'

puts "Running Rails App..."
run Rails.application

puts "Rails app running."

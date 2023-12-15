# frozen_string_literal: true

require './src/platform'

platform = Platform.new(File.read(ARGV[0] || 'test_input.txt').split("\n").map { _1.split('') })
platform.tilt_north!
puts platform.count_load

# frozen_string_literal: true

require './src/cosmos'

cosmos = Cosmos.new(File.read(ARGV[0] || 'test_input.txt'))
cosmos.expand!

pairs = cosmos.galaxies.product(cosmos.galaxies).reject { |(g1, g2)| g1 == g2 }
              .uniq { _1.to_set }

puts pairs.map { |(g1, g2)| (g1.x - g2.x).abs + (g1.y - g2.y).abs }.sum

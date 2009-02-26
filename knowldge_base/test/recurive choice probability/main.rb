#!/usr/bin/ruby

require 'yaml'
require 'lib/rp-choice.rb'

stats = {}

1.upto(10) do |set_size|
	set = (0 ... set_size).to_a
	1.upto(100) do |runs|
		stats[[set_size,runs]] = RPChoice.run set, runs
	end
end

File.open 'cache.yaml', 'w' do |cache|
	cache.write stats.to_yaml
end # file

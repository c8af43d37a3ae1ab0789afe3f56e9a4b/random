#!/usr/bin/ruby

require 'dm_core'

Dir[File::join(File::split(__FILE__).first,'lib/*')].each do |path|
	require path
end

# Update all ORM mappings
DataMapper::auto_migrate!

threads = []

if ARGV.empty?
	FourChan::board(:b).threads do |thread|
		threads << thread
	end
else
	ARGV.each do |thread|
		threads << FourChan::thread(thread)
	end
end

threads.each do |thread|
	thread.posts
end

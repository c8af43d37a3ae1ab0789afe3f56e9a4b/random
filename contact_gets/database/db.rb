require 'yaml'
require 'pp'
require 'fileutils'
require 'activerecord'

module Database

	def self.migrate

		location = __FILE__
		location_split = File::split location
		file = location_split.pop
		directory = location_split.pop

		Dir[File::join(directory,'*.rb')].each do |path|
			require path unless path == location
		end

		self.constants.each do |constant|
			if ActiveRecord::Migration === constant
				constant.migrate :up
			end
		end

	end
end

if $0 == __FILE__

	Database.migrate
end

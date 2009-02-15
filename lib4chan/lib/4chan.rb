$LOAD_PATH << File::split(__FILE__).first

require 'Homepage.rb'
require 'Thread.rb'
require 'Threads.rb'
require 'Post.rb'
require 'DomFetcher.rb'
require 'ThreadSummary.rb'
require 'ThreadSummaries.rb'
require 'ThreadSummarizer.rb'

module FourChan

	HomepageURL = URI::parse "http://www.4chan.org/"

	# Module Methods
	class << self
		# Nice recursive self resolution for convenience
		# Don't be tricked guys, your cant get anything but methods from here.
		def new
			self
		end
	
		# Surface methods

		def home
			Homepage.new HomepageURL
		end
		alias homepage home

		def thread url
			Thread.new url
		end

		def board url
			Board.new url
		end

		def boards
			home.boards
		end
	end

private

	Resolution = Struct.new :x, :y
	ImageLink = Struct.new :link, :text, :file_size, :resolution
	Thumbnail = Struct.new :source, :resolution
	ThreadLink = Struct.new :link, :text
	Poster = Struct.new :name, :email, :trip

end

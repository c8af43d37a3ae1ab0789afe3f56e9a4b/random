require 'hpricot'
require 'open-uri'

$LOAD_PATH << File::split(__FILE__).first

require 'Homepage.rb'
require 'Thread.rb'

module FourChan

	HomepageURL = URI::parse "http://www.4chan.org/"
	Resolution = Struct.new :x, :y
	ImageLink = Struct.new :link, :text, :file_size, :resolution
	Thumbnail = Struct.new :source, :resolution
	ThreadLink = Struct.new :link, :text
	Poster = Struct.new :name, :email, :trip

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

		def thread
			raise 'incomplete'
		end

		def board
			raise 'incomplete'
		end

		def boards
			raise 'incomplete'
		end
	end

	private

	class Homepage
		def initialize uri
			buildThreadSummaries
		end
		def threadSummaries
			@thread_summaries
		end
		def threads
			@threa_summaries.map do |summary|
				summary.thread
			end
		end

		private

		def buildThreadSummaries
			@thread_summaries = ThreadSummaries.new

			connection = open HomepageURL
			dom = Hpricot.parse connection
			( dom / "#popular-threads" / ".boxcontent" / "li" ).each do |thread_element|
				summary = ThreadSummary.new

				prefix = thread_element.inner_text
				if prefix =~ /\S/
					summary.prefix = prefix.strip
				end

				( thread_element / 'a' ).each do |link_element|

					link_text = link_element.attributes['href']
					link_match = link_text.match(/(.*)#(\d+)$/)
					link_link = link_match[1]
					link_text = link_element.inner_text

					summary.post_number = link_match[2]

					summary.thread_link = ThreadLink.new link_link, link_text

					buildSummaryInternals summary, link_element.attributes['title']
				end

				@thread_summaries << summary
			end
		end
		def buildSummaryInternals summary, string

			date_match = string.match %r{\d+/\d+/\d+\(\w+\)\d+:\d+}

			summary.date = date_match[0]

			dom = Hpricot::parse string

			poster_name = nil
			poster_email = nil
			poster_trip = nil

			( dom / 'span.p_postername' ).each do |name_element|
				poster_name = name_element.inner_text
			end

			( dom / 'span.postertrip' ).each do |trip_element|
				poster_trip = trip_element.inner_text
			end

			if poster_name || poster_email || poster_trip
				summary.poster = Poster.new poster_name, poster_email, poster_trip
			end

			summary.post_text = nil
			( dom / "div.post blockquote" ).each do |quote_element|
				summary.post_text = quote_element.inner_html
			end

			( dom / "div.post span.p_filesize" ).each do |thread_link_text|
				raw_text = thread_link_text.inner_text
				match = raw_text.match /-\((\d+) ([A-Z]+), (\d+)x(\d+), (.*)\)/m

				size_num = match[1].to_i
				size_scale = match[2]
				size = size_scale.split(//).inject(size_num) {|result,letter|
					case letter
					when /k/i
						1024 * result
					when /m/i
						1024 ** 2 * result
					when /g/i
						1024 ** 3 * result
					else
						result
					end
				}

				resolution = Resolution.new match[3], match[4]
				name = match[5]

				link_link = nil
				link_text = nil
				( thread_link_text / 'a' ).each do |link_element|
					link_link = link_element.attributes['href']
					link_text = link_element.inner_text.strip.gsub /^"|"$/, ''
				end

				summary.image_link = ImageLink.new link_link, link_text, size, resolution
			end
			( dom / "div.post img" ).each do |image_element|
				link = image_element.attributes['src']
				x_res = image_element.attributes['width']
				y_res = image_element.attributes['height']

				summary.thumbnail = Thumbnail.new link, Resolution.new(x_res, y_res)
			end
		end
	end
end

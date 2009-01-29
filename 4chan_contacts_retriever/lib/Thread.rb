module FourChan
	class ThreadSummaries < Array
	end
	class ThreadSummary
			Attributes = %w{
				prefix

				thread_link

				image_link

				thumbnail

				poster
				
				post_number
				post_text

				date
			}
			Attributes.each do |key|
				attr_accessor key.to_sym
			end

		def thread
			Thread.new URI::parse(thread_link.link)
		end
	end
	class Threads < Hash
		def << thread
		end
	end
	class Thread
		def initialize uri
			connection = open uri
			dom = Hpricot::parse connection
		end
	end
end

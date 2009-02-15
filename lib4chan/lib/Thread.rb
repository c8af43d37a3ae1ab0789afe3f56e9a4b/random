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
	class Threads < Array
	end
	class Thread

		attr :posts

		def initialize uri
			@posts = Posts.new

			dom = fetchDom uri

			parse_dom dom
		end

		private

		def parse_dom dom
			( dom / 'td.reply' ).each do |post_element|
				attributes = parse_post_element post_element

				@posts << Post.new(attributes)
			end
		end

		def parse_post_element post_element
				post_attributes = Hash.new

				post_attributes["id"] = post_element.attributes['id']

			( post_element / 'blockquote' ).each do |text_element|
				post_attributes['text'] = text_element.inner_html
			end

			return post_attributes
		end

	end
end

module FourChan
	class Thread

		attr :posts

		def initialize uri
			@posts = Posts.new

			dom = DomFetcher::fetch uri

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

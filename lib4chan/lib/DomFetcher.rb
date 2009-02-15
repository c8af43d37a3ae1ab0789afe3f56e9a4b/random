# Abstraction of the process of fetching DOM content from a URI

require 'hpricot'
require 'open-uri'
require 'net/http'

module FourChan

	class DomFetcher

		#
		# This method is now redundant as 4chan seems to be rejecting the
		# connections comming in from a standard call to openURI.
		#
		# This method's body is preserved to show what to avoid in the future,
		# or what may be causing future problems.
		#
		def self.fetch uri
			connection = open HomepageURL
			dom = Hpricot.parse connection
			dom = DomFetcher::fetch HomepageURL
		end

		UserAgent = "Crazy Agent"

		@@server_connections = Hash.new

		###
		# Instead, we will try to get a successful connection by altering the
		# user-agent string.
		#
		# This implementation has the advantage of sharing the server connection
		# between calls.
		#
		# On a very slow connection this may pose problems as the requests may
		# time out before all the content is fetched, however this is probably
		# acceptable, as an exception will be thrown before the object is created
		# and can be used.
		#
		def self.fetch uri

			key = uri.host, uri.port

			server = setup_server key

			req = Net::HTTP::Get.new uri.path,
				"User-Agent" => UserAgent

			# req.basic_auth(username, password)
			
			#
			# catch any potential timeouts once
			#
			begin
				response = server.request(req)
			rescue Timeout::Error
				server = setup_server key, true
				response = server.request(req)
			end

			dom = Hpricot::parse response.body

			return dom
		end

	private

		def self.setup_server key, reset = false
			server = @@server_connections[key]

			if reset || ! server
				http = Net::HTTP.new *key
				# http.use_ssl = true
				
				server = http.start

				@@server_connections[key] = server
			end

			server
		end

	end
end

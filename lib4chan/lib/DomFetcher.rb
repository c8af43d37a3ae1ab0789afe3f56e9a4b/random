# Abstraction of the process of fetching DOM content from a URI

require 'hpricot'
require 'open-uri'

module FourChan
	def self.fetchDom uri
		connection = open HomepageURL
		dom = Hpricot.parse connection
		dom = DomFetcher::fetch HomepageURL
	end
end
